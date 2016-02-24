#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Description=Equal but random grouping
#AutoIt3Wrapper_Res_Fileversion=1.0
#AutoIt3Wrapper_Res_LegalCopyright=GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
#AutoIt3Wrapper_Res_Field=Made by|Greif5
#AutoIt3Wrapper_Res_Field=Compile Date|%date% %time%
#AutoIt3Wrapper_Res_Field=GitHub| https://github.com/greif5
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Global $var_Version	="1.0"


#Region ### START Inclue section ### Form=
#include <Array.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>
#EndRegion ### END Inclue section ###

#Region ### START Deklaration ### Form=

$Form_Main	= ""
$Edit		= ""
$Bu_Run		= ""

$var_Form_B	= 250
$var_Form_H	= 400

$pos_Form_B	= (@DesktopWidth / 2 ) - ($var_Form_B / 2)
$pos_Form_H	= (@DesktopHeight / 2) - ($var_Form_H / 2)

#EndRegion ### END Deklaration ###

#Region ### START Main-GUI ### Form=
Opt ('GUIoneventmode', 1)

$Form_Main	 	= GUICreate("Random Students", $var_Form_B, $var_Form_H, $pos_Form_B, $pos_Form_H)
$Edit			= GUICtrlCreateEdit("",5,5,$var_Form_B-10,$var_Form_H-60)

$Bu_Run			= GUICtrlCreateButton("Start", 		($var_Form_B/2)-40,	$var_Form_H-40, 80, 30)
GUISetState(@SW_SHOW)

GUISetOnEvent ($GUI_EVENT_CLOSE, "_Exit", $Form_Main)
GUICtrlSetOnEvent($Bu_Run, "_Run")

While(1)
   Sleep(100)
WEnd
#EndRegion ### END Main-GUI ###


#Region ### START Funktionen ### Form=

Func _CheckArray($Array)
	$count = 1

	While($count < $Array[0])
		$temp1 = StringSplit($Array[$count],"#")
		$temp2 = StringSplit($Array[$count+1],"#")

		If $temp1[1] = $temp2[1] Then
			$Array[$count] = Random(0,256,1) &"#" & $temp1[2]
			_ArraySort($Array,0,1)
			$Array = _CheckArray($Array)
		EndIf

		$count = $count + 1
	WEnd
	Return $Array
EndFunc

Func _Exit()
   Exit
EndFunc

Func _Run()
   $var_Studenten = _GUICtrlEdit_GetText($Edit)

	If NOT $var_Studenten = "" Then

		$var_GruppenAnz	= InputBox("Gruppengröße","Geben Sie die Anzahl der Studenten pro Gruppe an")

		If NOT $var_GruppenAnz = "" Then
			If StringIsDigit($var_GruppenAnz) Then
				If $var_GruppenAnz > 0 Then
					$var_GruppenAnz = Int($var_GruppenAnz)
					$var_Studenten = StringSplit($var_Studenten,@LF)

					If $var_Studenten[0] <= 256 Then

						If $var_Studenten[0] < $var_GruppenAnz Then
							$var_GruppenAnz = $var_Studenten[0]
						EndIf

						$count = 1
						While($count <= $var_Studenten[0])
							$var_Studenten[$count] = StringReplace($var_Studenten[$count],@CR,"")
							$var_Studenten[$count] = StringReplace($var_Studenten[$count],@LF,"")
							$var_Studenten[$count] = StringReplace($var_Studenten[$count],@CRLF,"")
							$var_Studenten[$count] = Random(0,256,1) &"#" & $var_Studenten[$count]
							$count = $count + 1
						WEnd

						_ArraySort($var_Studenten,0,1)
						$var_Studenten = _CheckArray($var_Studenten)


						$count_Gruppe 	= 1
						$count_Student	= 1

						$Anz_Gruppen = Ceiling($var_Studenten[0] / $var_GruppenAnz)

						Dim $var_Gruppen[256][256]
						ReDim $var_Gruppen[$var_GruppenAnz+1][$Anz_Gruppen+1]

						While($count_Student <= $var_Studenten[0])
							$count_Anz		= 1
							While($count_Anz <= $var_GruppenAnz)
								If $count_Student <= $var_Studenten[0] Then
									$temp1 = StringSplit($var_Studenten[$count_Student],"#")
									If $temp1[2] = "" Then
										$count_Anz = $count_Anz - 1
									Else
										$var_Gruppen[$count_Anz][$count_Gruppe] = $temp1[2]
									EndIf
								EndIf
								$count_Anz = $count_Anz + 1
								$count_Student = $count_Student + 1
							WEnd

							$count_Gruppe = $count_Gruppe + 1
						WEnd

						_ArrayDisplay($var_Gruppen)

					Else
						MsgBox(0,"Error","Zu viele Studenten")
					EndIf
				Else
					MsgBox(0,"Error","Es muss mind. ein Student pro Gruppe geben")
				EndIf
			Else
			 MsgBox(0,"Error","Studenten pro Gruppe ist keine Zahl")
			EndIf
		Else
			MsgBox(0,"Error","Studenten pro Gruppe kann nicht leer sein")
		EndIf
	Else
		MsgBox(0,"Error","Keine Studenten angegeben")
	EndIf

EndFunc

#EndRegion ### END Funktionen ###



#Region ### START XXXX ### Form=
#EndRegion ### END XXXX ###