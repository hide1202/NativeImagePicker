using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public delegate void OnReceiveImageData(byte[] imageBytes);

public static class NativeImagePicker
{
	const string RECEIVER_NAME = "NativeImagePickerReceiver";
	const string RECEIVER_METHOD_NAME = "OnPick";

	static int _callbackIndex = 0;
	static Dictionary<int, OnReceiveImageData> _callbacks;

	static GameObject _callbackReceiver;
	static NativeImagePicker()
	{
		if(_callbackReceiver == null)
		{
			_callbackReceiver = new GameObject(RECEIVER_NAME);
			_callbackReceiver.AddComponent<NativeImagePickerReceiver>();
		}

		if(_callbacks == null)
		{
			_callbacks = new Dictionary<int, OnReceiveImageData>();
		}

		_callbackIndex = 0;
	}

	public static void Pick(OnReceiveImageData callback)
	{
		int callbackNum = ++_callbackIndex;
		_callbacks[callbackNum] = callback;
		NativePick(callbackNum);
	}

	public static byte[] GetImageData()
	{
		string base64Result = NativeGetImageBase64Data();
		if(string.IsNullOrEmpty(base64Result))
			return null;
		return System.Convert.FromBase64String(base64Result);
	}

	public static OnReceiveImageData GetCallback(int callbackNum)
	{
		return _callbacks.ContainsKey(callbackNum) ? _callbacks[callbackNum] : null;
	}

#if UNITY_IPHONE
	[DllImport("__Internal")]
	private static extern void NativePick(int callbackNum);
	[DllImport("__Internal")]
	private static extern string NativeGetImageBase64Data();
#elif UNITY_ANDROID
	static AndroidJavaClass _cls = new AndroidJavaClass("com.viewpoint.pickerplugin.PickerPlugin");
	private static void NativePick(int callbackNum) 
	{
		_cls.CallStatic("pick", callbackNum);
	}
	private static string NativeGetImageBase64Data() 
	{ 
		return _cls.CallStatic<string>("getImageBase64Data"); 
	}
#else
    private static void NativePick(int callbackNum) { }
    private static string NativeGetImageBase64Data() { return null; }
#endif
}