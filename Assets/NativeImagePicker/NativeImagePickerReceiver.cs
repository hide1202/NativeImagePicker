using UnityEngine;
using System.Collections;

public class NativeImagePickerReceiver : MonoBehaviour 
{
	public void OnPick(string callbackNum)
	{
		int n = -1;
		if(int.TryParse(callbackNum, out n))
		{
			var callback = NativeImagePicker.GetCallback(n);
			callback(NativeImagePicker.GetImageData());
		}
	}
}
