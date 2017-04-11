#ifndef JAVA_TO_CPP_BIND_H
#define JAVA_TO_CPP_BIND_H

#include <jni.h>
#include <QAndroidJniEnvironment>
#include "../cpp/pushnotificationtokenlistener.h"

static void tokenUpdateNotify(JNIEnv *env, jobject obj, jstring token)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)
    PushNotificationTokenListener::tokenUpdateNotify(env->GetStringUTFChars(token,0));
}

static void pushNotificationNotify(JNIEnv *env, jobject obj, jstring messageData)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)
    PushNotificationTokenListener::pushNotificationNotify(env->GetStringUTFChars(messageData,0));
}

static JNINativeMethod methodsArray[] =
{
    {"tokenUpdateNotify", "(Ljava/lang/String;)V", (void *) tokenUpdateNotify},
    {"pushNotificationNotify", "(Ljava/lang/String;)V", (void *) pushNotificationNotify},
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
