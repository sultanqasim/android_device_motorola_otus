LOCAL_PATH := $(call my-dir)

## Imported from the original makefile...
KERNEL_CONFIG := $(KERNEL_OUT)/.config
KERNEL_ZIMG = $(KERNEL_OUT)/arch/arm/boot/zImage-dtb

## Build and run dtbtool
DTBTOOL := $(TARGET_KERNEL_SOURCE)/tools/dtbtool/dtbtool
$(DTBTOOL):
	make -C $(TARGET_KERNEL_SOURCE)/tools/dtbtool

# Hack to build appended DTB zImage and make the build system think it is a normal zImage
$(KERNEL_ZIMG): $(INSTALLED_KERNEL_TARGET)
	make -C $(TARGET_KERNEL_SOURCE) zImage-dtb O=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE)
	cp $(KERNEL_ZIMG) $(INSTALLED_KERNEL_TARGET)

INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/dt.img

$(INSTALLED_DTIMAGE_TARGET): $(DTBTOOL) $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr $(INSTALLED_KERNEL_TARGET)
	@echo -e ${CL_CYN}"Start DT image: $@"${CL_RST}
	$(call pretty,"Target dt image: $(INSTALLED_DTIMAGE_TARGET)")
	$(hide) $(DTBTOOL) -o $(INSTALLED_DTIMAGE_TARGET) -s $(BOARD_KERNEL_PAGESIZE) -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/arch/arm/boot/
	@echo -e ${CL_CYN}"Made DT image: $@"${CL_RST}

## Overload bootimg generation: Same as the original, + --dt arg
$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(INSTALLED_DTIMAGE_TARGET) $(KERNEL_ZIMG)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --dt $(INSTALLED_DTIMAGE_TARGET) --output $@
	@echo -e ${CL_CYN}"Made boot image: $@"${CL_RST}

## Overload recoveryimg generation: Same as the original, + --dt arg
$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_DTIMAGE_TARGET) $(recovery_ramdisk) $(recovery_kernel) $(KERNEL_ZIMG)
	@echo -e ${CL_CYN}"----- Making recovery image ------"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --dt $(INSTALLED_DTIMAGE_TARGET) --output $@
	@echo -e ${CL_CYN}"Made recovery image: $@"${CL_RST}
