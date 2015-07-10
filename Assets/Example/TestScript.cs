using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class TestScript : MonoBehaviour 
{
	public Image image;
	public void OnPick()
	{
		NativeImagePicker.Pick(bytes => {
			Texture2D tx = new Texture2D(160, 160);
			tx.LoadImage(bytes);
			image.sprite = Sprite.Create(tx, new Rect(0.0f, 0.0f, tx.width, tx.height), Vector2.one * 0.5f);
		});
	}
}
