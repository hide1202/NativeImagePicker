//
//  PickerInterface.h
//
//
//  Created by VIEWPOINT on 2015. 7. 9..
//
//

#ifndef PickerInterface_h
#define PickerInterface_h

extern "C"
{
	void NativePick(int callbackNum);
	char* NativeGetImageBase64Data();
}

#endif /* PickerInterface_h */
