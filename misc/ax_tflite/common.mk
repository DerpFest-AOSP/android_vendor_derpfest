PRODUCT_PACKAGES += \
    libtensorflowlite_jni \
    libtensorflowlite_gpu_jni \
    libtensorflowlite_xnnpack_jni

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/lib/libtensorflowlite_jni.so \
    system/lib64/libtensorflowlite_jni.so \
    system/lib/libtensorflowlite_gpu_jni.so \
    system/lib64/libtensorflowlite_gpu_jni.so \
    system/lib/libtensorflowlite_xnnpack_jni.so \
    system/lib64/libtensorflowlite_xnnpack_jni.so
