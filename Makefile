CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)gcc

# Be silent per default, but 'make V=1' will show all compiler calls
ifneq ($(V),1)
Q := @
endif

CFLAGS += -Wall -O2 -g
CFLAGS += \
	-nostdlibinc \
	-mthumb \
	-msoft-float \
	-march=armv7-a \
	-mfloat-abi=softfp \
	-mfpu=neon \
	-mcpu=cortex-a15 \
	-mfpu=neon-vfpv4 \
	-D__ARM_FEATURE_LPAE=1 \
	-I$(ANDROID_BUILD_TOP)/bionic/libc/include \
	-D__LIBC_API__=10000 \
	-D__LIBM_API__=10000 \
	-D__LIBDL_API__=10000 \
	-isystem $(ANDROID_BUILD_TOP)/bionic/libc/include \
	-isystem $(ANDROID_BUILD_TOP)/bionic/libc/kernel/uapi \
	-isystem $(ANDROID_BUILD_TOP)/bionic/libc/kernel/uapi/asm-arm \
	-isystem $(ANDROID_BUILD_TOP)/bionic/libc/kernel/android/scsi \
	-isystem $(ANDROID_BUILD_TOP)/bionic/libc/kernel/android/uapi \
	-target armv7a-linux-androideabi \
	-B$(GCC_DIR)/arm-linux-androideabi/bin \
	-fPIE \
	-D_USING_LIBCXX \
	-std=gnu99
LDFLAGS += \
	$(ANDROID_BUILD_TOP)/out/soong/.intermediates/bionic/libc/crtbegin_dynamic/android_arm_armv7-a-neon_cortex-a15_core/crtbegin_dynamic.o \
	-Wl,--start-group \
	$(ANDROID_BUILD_TOP)/prebuilts/clang/host/linux-x86/clang-r353983c/lib64/clang/9.0.3/lib/linux/libclang_rt.builtins-arm-android.a \
	$(ANDROID_BUILD_TOP)/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/arm-linux-androideabi/lib/libatomic.a \
	$(ANDROID_BUILD_TOP)/out/soong/.intermediates/build/soong/libgcc_stripped/android_arm_armv7-a-neon_cortex-a15_core_static/libgcc_stripped.a \
	-Wl,--end-group \
	$(ANDROID_BUILD_TOP)/out/soong/.intermediates/bionic/libc/libc/android_arm_armv7-a-neon_cortex-a15_core_shared_10000/libc.so \
	$(ANDROID_BUILD_TOP)/out/soong/.intermediates/bionic/libm/libm/android_arm_armv7-a-neon_cortex-a15_core_shared_10000/libm.so \
	$(ANDROID_BUILD_TOP)/out/soong/.intermediates/bionic/libc/crtend_android/android_arm_armv7-a-neon_cortex-a15_core/obj/bionic/libc/arch-common/bionic/crtend.o \
	-target armv7a-linux-androideabi \
	-B$(GCC_DIR)/bin \
	-fuse-ld=lld \
	-pie \
	-nostdlib \
	-Bdynamic \
	-Wl,-dynamic-linker,/system/bin/linker

OBJS = main.o
OUT = main

all: $(OUT)

$(OUT): $(OBJS)
	@printf "  LD      $@\n"
	$(Q)$(LD) $(LDFLAGS) $(OBJS) -o $@

%.o: %.c
	@printf "  CC      $(*).c\n"
	$(Q)$(CC) $(CFLAGS) -o $(*).o -c $(*).c

clean:
	@printf "  CLEAN\n"
	$(Q)-rm -f $(OBJS) $(OUT)

.PHONY: all clean
