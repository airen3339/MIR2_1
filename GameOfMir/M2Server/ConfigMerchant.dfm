object frmConfigMerchant: TfrmConfigMerchant
  Left = 119
  Top = 138
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '����NPC����'
  ClientHeight = 468
  ClientWidth = 1028
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '����'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 81
    Height = 15
    Caption = 'NPC�б�:'
  end
  object ListBoxMerChant: TListBox
    Left = 10
    Top = 30
    Width = 501
    Height = 211
    ItemHeight = 15
    TabOrder = 0
    OnClick = ListBoxMerChantClick
  end
  object GroupBoxNPC: TGroupBox
    Left = 10
    Top = 250
    Width = 501
    Height = 171
    Enabled = False
    TabOrder = 1
    object Label2: TLabel
      Left = 10
      Top = 25
      Width = 68
      Height = 15
      Caption = '�ű�����:'
    end
    object Label3: TLabel
      Left = 260
      Top = 25
      Width = 26
      Height = 15
      Caption = '��ͼ����:'
    end
    object Label4: TLabel
      Left = 10
      Top = 55
      Width = 10
      Height = 15
      Caption = '����X:'
    end
    object Label5: TLabel
      Left = 150
      Top = 55
      Width = 10
      Height = 15
      Caption = '����Y:'
    end
    object Label6: TLabel
      Left = 10
      Top = 85
      Width = 78
      Height = 15
      Caption = '��ʾ����:'
    end
    object Label7: TLabel
      Left = 260
      Top = 85
      Width = 19
      Height = 15
      Caption = '����:'
    end
    object Label8: TLabel
      Left = 380
      Top = 85
      Width = 28
      Height = 15
      Caption = '����:'
    end
    object Label10: TLabel
      Left = 260
      Top = 55
      Width = 69
      Height = 15
      Caption = '��ͼ����:'
    end
    object Label11: TLabel
      Left = 360
      Top = 115
      Width = 55
      Height = 15
      Caption = '�ƶ����:'
    end
    object EditScriptName: TEdit
      Left = 80
      Top = 20
      Width = 151
      Height = 23
      Hint = '�ű��ļ�����.�ļ������Դ����ּӵ�ͼ�����Ϊʵ���ļ���.'
      TabOrder = 0
      OnChange = EditScriptNameChange
    end
    object EditMapName: TEdit
      Left = 330
      Top = 20
      Width = 151
      Height = 23
      Hint = '��ͼ����.'
      TabOrder = 1
      OnChange = EditMapNameChange
    end
    object EditShowName: TEdit
      Left = 88
      Top = 80
      Width = 151
      Height = 23
      TabOrder = 2
      OnChange = EditShowNameChange
    end
    object CheckBoxOfCastle: TCheckBox
      Left = 80
      Top = 110
      Width = 101
      Height = 21
      Hint = 'ָ����NPC���ڳǱ�����,������ʱNPC��ֹͣӪҵ.'
      Caption = '���ڳǱ�'
      TabOrder = 3
      OnClick = CheckBoxOfCastleClick
    end
    object ComboBoxDir: TComboBox
      Left = 300
      Top = 80
      Width = 61
      Height = 23
      Hint = 'Ĭ��վ������.'
      Style = csDropDownList
      ItemHeight = 15
      TabOrder = 4
      OnChange = ComboBoxDirChange
    end
    object EditImageIdx: TSpinEdit
      Left = 420
      Top = 79
      Width = 61
      Height = 24
      Hint = '���ͼ��.'
      EditorEnabled = False
      MaxValue = 65535
      MinValue = 0
      TabOrder = 5
      Value = 0
      OnChange = EditImageIdxChange
    end
    object EditX: TSpinEdit
      Left = 80
      Top = 49
      Width = 61
      Height = 24
      Hint = '��ǰ����X.'
      EditorEnabled = False
      MaxValue = 1000
      MinValue = 1
      TabOrder = 6
      Value = 1
      OnChange = EditXChange
    end
    object EditY: TSpinEdit
      Left = 170
      Top = 49
      Width = 61
      Height = 24
      Hint = '��ǰ����Y.'
      EditorEnabled = False
      MaxValue = 1000
      MinValue = 1
      TabOrder = 7
      Value = 1
      OnChange = EditYChange
    end
    object EditMapDesc: TEdit
      Left = 330
      Top = 50
      Width = 151
      Height = 23
      Enabled = False
      ReadOnly = True
      TabOrder = 8
    end
    object CheckBoxAutoMove: TCheckBox
      Left = 260
      Top = 110
      Width = 85
      Height = 21
      Hint = 'NPC���ڵ�ͼ��������ƶ�'
      Caption = '�Զ��ƶ�'
      TabOrder = 9
      OnClick = CheckBoxAutoMoveClick
    end
    object EditMoveTime: TSpinEdit
      Left = 430
      Top = 109
      Width = 51
      Height = 24
      Hint = '����ƶ����ʱ����'
      EditorEnabled = False
      MaxValue = 65535
      MinValue = 0
      TabOrder = 10
      Value = 0
      OnChange = EditMoveTimeChange
    end
  end
  object GroupBoxScript: TGroupBox
    Left = 520
    Top = 10
    Width = 501
    Height = 451
    Enabled = False
    TabOrder = 2
    object MemoScript: TMemo
      Left = 10
      Top = 170
      Width = 481
      Height = 271
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = MemoScriptChange
    end
    object ButtonScriptSave: TButton
      Left = 420
      Top = 30
      Width = 71
      Height = 31
      Hint = '����ű��ļ�'
      Caption = '����(&S)'
      TabOrder = 1
      OnClick = ButtonScriptSaveClick
    end
    object GroupBox3: TGroupBox
      Left = 10
      Top = 20
      Width = 401
      Height = 141
      Caption = '�ű�����'
      TabOrder = 2
      object Label9: TLabel
        Left = 10
        Top = 110
        Width = 57
        Height = 15
        Caption = '�����ۿ�:'
      end
      object CheckBoxBuy: TCheckBox
        Left = 10
        Top = 20
        Width = 41
        Height = 21
        Caption = '��'
        TabOrder = 0
        OnClick = CheckBoxBuyClick
      end
      object CheckBoxSell: TCheckBox
        Left = 10
        Top = 40
        Width = 41
        Height = 21
        Caption = '��'
        TabOrder = 1
        OnClick = CheckBoxSellClick
      end
      object CheckBoxStorage: TCheckBox
        Left = 90
        Top = 40
        Width = 81
        Height = 21
        Caption = 'ȡ�ֿ�'
        TabOrder = 2
        OnClick = CheckBoxStorageClick
      end
      object CheckBoxGetback: TCheckBox
        Left = 90
        Top = 20
        Width = 81
        Height = 21
        Caption = '��ֿ�'
        TabOrder = 3
        OnClick = CheckBoxGetbackClick
      end
      object CheckBoxMakedrug: TCheckBox
        Left = 300
        Top = 60
        Width = 91
        Height = 21
        Caption = '�ϳ���Ʒ'
        TabOrder = 4
        OnClick = CheckBoxMakedrugClick
      end
      object CheckBoxUpgradenow: TCheckBox
        Left = 190
        Top = 20
        Width = 91
        Height = 21
        Caption = '��������'
        TabOrder = 5
        OnClick = CheckBoxUpgradenowClick
      end
      object CheckBoxGetbackupgnow: TCheckBox
        Left = 190
        Top = 40
        Width = 91
        Height = 21
        Caption = 'ȡ������'
        TabOrder = 6
        OnClick = CheckBoxGetbackupgnowClick
      end
      object CheckBoxRepair: TCheckBox
        Left = 300
        Top = 20
        Width = 91
        Height = 21
        Caption = '������Ʒ'
        TabOrder = 7
        OnClick = CheckBoxRepairClick
      end
      object CheckBoxS_repair: TCheckBox
        Left = 300
        Top = 40
        Width = 91
        Height = 21
        Caption = '��������'
        TabOrder = 8
        OnClick = CheckBoxS_repairClick
      end
      object EditPriceRate: TSpinEdit
        Left = 80
        Top = 105
        Width = 61
        Height = 24
        Hint = 'NPC����ʱ�ۿ�,80Ϊ80%'
        EditorEnabled = False
        MaxValue = 500
        MinValue = 60
        TabOrder = 9
        Value = 60
        OnChange = EditPriceRateChange
      end
      object CheckBoxSendMsg: TCheckBox
        Left = 90
        Top = 60
        Width = 103
        Height = 21
        Caption = 'ף����'
        TabOrder = 10
        OnClick = CheckBoxSendMsgClick
      end
    end
    object ButtonReLoadNpc: TButton
      Left = 420
      Top = 70
      Width = 71
      Height = 31
      Hint = '���¼���NPC�ű�.'
      Caption = '����(&L)'
      Enabled = False
      TabOrder = 3
      OnClick = ButtonReLoadNpcClick
    end
  end
  object ButtonSave: TButton
    Left = 10
    Top = 430
    Width = 71
    Height = 31
    Hint = '���潻��NPC����'
    Caption = '����(&S)'
    TabOrder = 3
    OnClick = ButtonSaveClick
  end
  object CheckBoxDenyRefStatus: TCheckBox
    Left = 378
    Top = 430
    Width = 119
    Height = 21
    Hint = 'ʹ�ô˷���,����ˢ��NPC����Ϸ�е�����,�򿪴�ѡ�����ٹر�,NPC���ĵĲ����ͻ�����Ϸ��ˢ��.'
    Caption = 'ˢ��״̬'
    TabOrder = 4
    OnClick = CheckBoxDenyRefStatusClick
  end
  object ButtonClearTempData: TButton
    Left = 210
    Top = 430
    Width = 111
    Height = 31
    Hint = '�������NPC����ʱ�ļ�,������ʱ�۸��������Ʒ���,��NPC������Ʒ������ʱ��ʹ�ô˹�������.'
    Caption = '�������(&C)'
    TabOrder = 5
    OnClick = ButtonClearTempDataClick
  end
  object ButtonViewData: TButton
    Left = 90
    Top = 430
    Width = 111
    Height = 31
    Caption = '�鿴����(&V)'
    TabOrder = 6
    Visible = False
    OnClick = ButtonClearTempDataClick
  end
end
