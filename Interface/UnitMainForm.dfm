object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'OneWay Backup'
  ClientHeight = 615
  ClientWidth = 1084
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 1084
    Height = 385
    Align = alClient
    BevelOuter = bvNone
    Caption = 'TopPanel'
    TabOrder = 0
    object LeftPanel: TPanel
      Left = 0
      Top = 60
      Width = 1084
      Height = 325
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object JobsList: TListView
        Left = 0
        Top = 25
        Width = 1084
        Height = 300
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = 'Project Name'
            Width = 200
          end
          item
            Caption = 'Source Folder'
          end
          item
            Caption = 'Destination Folder'
          end
          item
            Alignment = taCenter
            Caption = 'Buffer Size'
            Width = 100
          end>
        ReadOnly = True
        RowSelect = True
        PopupMenu = JobListMenu
        TabOrder = 0
        ViewStyle = vsReport
        OnMouseDown = JobsListMouseDown
      end
      object ActivatePanel: TPanel
        Left = 0
        Top = 0
        Width = 1084
        Height = 25
        Align = alTop
        TabOrder = 1
        object SelectAllLabel: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 54
          Height = 17
          Cursor = crHandPoint
          Align = alLeft
          Caption = 'Activate All'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsUnderline]
          ParentFont = False
          Layout = tlCenter
          OnClick = SelectAllLabelClick
          ExplicitHeight = 13
        end
        object SelectNoneLabel: TLabel
          AlignWithMargins = True
          Left = 64
          Top = 4
          Width = 66
          Height = 17
          Cursor = crHandPoint
          Align = alLeft
          Caption = 'Deactivate All'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsUnderline]
          ParentFont = False
          Layout = tlCenter
          OnClick = SelectNoneLabelClick
          ExplicitHeight = 13
        end
        object SelectReverseLabel: TLabel
          AlignWithMargins = True
          Left = 136
          Top = 4
          Width = 91
          Height = 17
          Cursor = crHandPoint
          Align = alLeft
          Caption = 'Reverse Activation'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsUnderline]
          ParentFont = False
          Layout = tlCenter
          OnClick = SelectReverseLabelClick
          ExplicitHeight = 13
        end
      end
    end
    object RightPanel: TPanel
      Left = 0
      Top = 0
      Width = 1084
      Height = 60
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object RunJobsBtn: TButton
        Left = 959
        Top = 0
        Width = 125
        Height = 60
        Align = alRight
        Caption = 'Run Selected Jobs'
        TabOrder = 0
        OnClick = RunJobsBtnClick
      end
      object AddNewProjectBtn: TButton
        Left = 125
        Top = 0
        Width = 125
        Height = 60
        Align = alLeft
        Caption = 'Add A New Project'
        TabOrder = 1
        OnClick = AddNewProjectBtnClick
      end
      object StopBtn: TButton
        Left = 834
        Top = 0
        Width = 125
        Height = 60
        Align = alRight
        Caption = 'Stop'
        Enabled = False
        TabOrder = 2
        OnClick = StopBtnClick
      end
      object EditProjectBtn: TButton
        Left = 0
        Top = 0
        Width = 125
        Height = 60
        Align = alLeft
        Caption = 'Edit Selected Project'
        TabOrder = 3
        OnClick = EditProjectBtnClick
      end
    end
  end
  object BottomPanel: TPanel
    Left = 0
    Top = 385
    Width = 1084
    Height = 230
    Align = alBottom
    TabOrder = 1
    object StateLabel: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 196
      Width = 1076
      Height = 13
      Align = alBottom
      ExplicitWidth = 3
    end
    object ProjectNameLabel: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 177
      Width = 1076
      Height = 13
      Align = alBottom
      ExplicitWidth = 3
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 212
      Width = 1082
      Height = 17
      Align = alBottom
      TabOrder = 0
    end
    object LogsPages: TJvPageControl
      Left = 1
      Top = 1
      Width = 1082
      Height = 173
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 1
      object TabSheet1: TTabSheet
        Caption = 'General Log'
        object LogList: TListView
          Left = 0
          Top = 0
          Width = 1074
          Height = 145
          Align = alClient
          Columns = <
            item
              Width = 125
            end
            item
              Width = 500
            end>
          GridLines = True
          HideSelection = False
          OwnerData = True
          ReadOnly = True
          RowSelect = True
          ShowColumnHeaders = False
          TabOrder = 0
          ViewStyle = vsReport
          OnData = LogListData
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Error Log'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object ErrorLog: TListView
          Left = 0
          Top = 0
          Width = 1074
          Height = 145
          Align = alClient
          Columns = <
            item
              Width = 125
            end
            item
            end>
          GridLines = True
          HideSelection = False
          OwnerData = True
          ReadOnly = True
          RowSelect = True
          ShowColumnHeaders = False
          TabOrder = 0
          ViewStyle = vsReport
          OnData = ErrorLogData
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Full Log'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object FullLogList: TListView
          Left = 0
          Top = 0
          Width = 1074
          Height = 145
          Align = alClient
          Columns = <
            item
              Width = 125
            end
            item
            end>
          GridLines = True
          HideSelection = False
          OwnerData = True
          ReadOnly = True
          RowSelect = True
          ShowColumnHeaders = False
          TabOrder = 0
          ViewStyle = vsReport
          OnData = FullLogListData
        end
      end
    end
  end
  object SearchSourceFiles: TJvSearchFiles
    Options = [soAllowDuplicates, soSearchDirs, soSearchFiles, soIncludeSystemHiddenDirs, soIncludeSystemHiddenFiles]
    DirParams.MinSize = 0
    DirParams.MaxSize = 0
    FileParams.MinSize = 0
    FileParams.MaxSize = 0
    OnFindFile = SearchSourceFilesFindFile
    OnFindDirectory = SearchSourceFilesFindDirectory
    Left = 488
    Top = 144
  end
  object ProgressTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = ProgressTimerTimer
    Left = 392
    Top = 96
  end
  object OperationThread: TIdThreadComponent
    Active = False
    Loop = False
    Priority = tpIdle
    StopMode = smTerminate
    OnException = OperationThreadException
    OnRun = OperationThreadRun
    Left = 593
    Top = 97
  end
  object SearchDestFiles: TJvSearchFiles
    Options = [soAllowDuplicates, soSearchDirs, soSearchFiles, soIncludeSystemHiddenDirs, soIncludeSystemHiddenFiles]
    DirParams.MinSize = 0
    DirParams.MaxSize = 0
    FileParams.MinSize = 0
    FileParams.MaxSize = 0
    OnFindFile = SearchSourceFilesFindFile
    OnFindDirectory = SearchDestFilesFindDirectory
    Left = 488
    Top = 96
  end
  object Taskbar1: TTaskbar
    TaskBarButtons = <>
    ProgressState = Normal
    TabProperties = []
    Left = 688
    Top = 104
  end
  object JobListMenu: TPopupMenu
    Left = 792
    Top = 100
    object O1: TMenuItem
      Caption = 'Open Source Directory'
      OnClick = O1Click
    end
    object O2: TMenuItem
      Caption = 'Open Destination Directory'
      OnClick = O2Click
    end
  end
end
