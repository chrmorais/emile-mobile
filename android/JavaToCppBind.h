#ifndef JAVA_TO_CPP_BIND_H
#define JAVA_TO_CPP_BIND_H

#include <jni.h>
#include <QAndroidJniEnvironment>
#include "cpp/pushnotificationtokenlistener.h"

static void tokenUpdateNotify(JNIEnv *env, jobject obj, jstring token)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)

    // Here call send the token to qml function
    PushNotificationTokenListener::tokenUpdateNotify(env->GetStringUTFChars(token,0));
}

static JNINativeMethod methodsArray[] =
{
    {"notifyTokenUpdate", "(Ljava/lang/String;)V", (void *) tokenUpdateNotify},
};

JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* reserved)
{
    (void)(reserved);
    JNIEnv* env;
    jclass javaClass;

    // if (vm->GetEnv(reinterpret_cast(&env), JNI_VERSION_1_6) < JNI_OK)
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK)
        return JNI_ERR;

    javaClass = env->FindClass("gsort/pos/engsisubiq/EmileMobile/TokenToApplication");
    if (!javaClass)
        return JNI_ERR;

    if (env->RegisterNatives(javaClass, methodsArray, sizeof(methodsArray) / sizeof(methodsArray[0])) < 0)
        return JNI_ERR;

    return JNI_VERSION_1_6;
}

#endif // JAVA_TO_CPP_BIND_H
