#ifndef JAVA_TO_CPP_BIND_H
#define JAVA_TO_CPP_BIND_H

#include <jni.h>
#include <QAndroidJniEnvironment>
#include "../cpp/emile.h"

static void eventNotify(JNIEnv *env, jobject obj, jstring eventName, jstring eventData)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)
    Emile::appNativeEventNotify(env->GetStringUTFChars(eventName,0), env->GetStringUTFChars(eventData,0));
}

static JNINativeMethod methodsArray[] =
{
    {"eventNotify", "(Ljava/lang/String;Ljava/lang/String;)V", (void *) eventNotify}
};

JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* reserved)
{
    (void)(reserved);
    JNIEnv* env;
    jclass javaClass;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK)
        return JNI_ERR;
    javaClass = env->FindClass("gsort/pos/engsisubiq/EmileMobile/ActivityToApplication");
    if (!javaClass)
        return JNI_ERR;
    if (env->RegisterNatives(javaClass, methodsArray, sizeof(methodsArray) / sizeof(methodsArray[0])) < 0)
        return JNI_ERR;
    return JNI_VERSION_1_6;
}

#endif // JAVA_TO_CPP_BIND_H
