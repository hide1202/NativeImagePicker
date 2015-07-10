package com.viewpoint.pickerplugin;

import java.io.ByteArrayOutputStream;

import com.unity3d.player.UnityPlayer;

import android.content.Intent;
import android.graphics.Bitmap;
import android.util.Base64;

public class PickerPlugin {
	static final String receiverName = "NativeImagePickerReceiver";
	static final String receiverMethod = "OnPick";

	static int _callbackNum = -1;
	static String _base64String = null;
	
	private static Bitmap cropCenter(Bitmap source)
	{
		if(source == null) return null;
		if(source.getWidth() == source.getHeight()) return source;
		
		int squareSide = source.getWidth() > source.getHeight() ? source.getHeight() : source.getWidth();
		int x = (int) ((source.getWidth() / 2.0f) - (squareSide / 2.0f));
		int y = (int) ((source.getHeight() / 2.0f) - (squareSide / 2.0f));
		
		return Bitmap.createBitmap(source, x, y, squareSide, squareSide);
	}

	public static void pick(int callbackNum) {
		_callbackNum = callbackNum;

		Intent intent = new Intent(UnityPlayer.currentActivity,
				PickerActivity.class);
		UnityPlayer.currentActivity.startActivity(intent);
	}

	public static void setBase64String(String base64String) {
		_base64String = base64String;
	}

	public static void returnUnity(Bitmap image) {
		if (image != null) {
			image = cropCenter(image);
			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			image.compress(Bitmap.CompressFormat.JPEG, 100,
					byteArrayOutputStream);
			byte[] byteArray = byteArrayOutputStream.toByteArray();
			_base64String = Base64.encodeToString(byteArray, Base64.DEFAULT);
		} else {
			_base64String = null;
		}
		UnityPlayer.UnitySendMessage(receiverName, receiverMethod, ""
				+ _callbackNum);
	}

	public static String getImageBase64Data() {
		return _base64String;
	}
}
