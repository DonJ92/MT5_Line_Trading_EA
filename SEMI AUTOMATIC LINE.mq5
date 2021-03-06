//+------------------------------------------------------------------+
//|                                          SEMI AUTOMATIC LINE.mq5 |
//|                                           Copyright 2020, SAT's. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SAT's."
#property link      ""
#property version   "1.0"
#property description "SEMI AUTOMATIC LINE"

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
const int DoubleClickDelayMillis = 600; // system default

color    mainPanel_BackgroundColor  = C'200,200,200';       // 内側の背景の色
color    mainPanel_BorderColor      = C'200,200,200';       // 内側の枠の色

string   common_Font                = "Yu Gothic Medium";   // 文字フォント
int      common_FontSize            = 10;
int      common_FontSize_XL         = 12;
color    common_FontColor           = clrBlack;
color    common_BackgroundColor     = C'216,216,216';
color    common_BorderColor         = clrGainsboro;         // Common Border Color

int      position_menu_FontSize     = 9;

color    subPanel_BackgroundColor   = C'240,240,240';       // Subpanel's Background Color
color    subPanel_BorderColor       = clrBlack;             // Subpanel's Border Color

// ポジションラベル＋ボタン
color    position_line_color                 = 0xF0F0F0;    // ポジションラベルの線の色
color    position_line_text_color            = 0x000000;    // ポジションラベルの文字色
color    position_line_button_color                 = 0xF0F0F0;    // ポジションメニューボタンの色
color    position_line_button_active_color          = 0xC0C0C0;    // ポジションメニューボタンの色（アクティブ時）
color    position_line_button_border_color          = 0xF0F0F0;    // ポジションメニューボタンの枠線の色
color    position_line_button_text_color            = 0x000000;    // ポジションメニューボタンの文字色

// ポジションTP、SLボタン
color    position_line_tp_button_color                 = 0xF0F0F0;    // ポジションメニューTPボタンの線の色
color    position_line_tp_button_border_color          = 0xF0F0F0;    // ポジションメニューTPボタンの枠線の色
color    position_line_tp_button_text_color            = 0x000000;    // ポジションメニューTPボタンの文字色
color    position_line_sl_button_color                 = 0xF0F0F0;    // ポジションメニューSLボタンの線の色
color    position_line_sl_button_border_color          = 0xF0F0F0;    // ポジションメニューSLボタンの枠線の色
color    position_line_sl_button_text_color            = 0x000000;    // ポジションメニューSLボタンの文字色
color    position_line_order_button_color                 = 0xF0F0F0;    // ポジションメニューORDERボタンの線の色
color    position_line_order_button_border_color          = 0xF0F0F0;    // ポジションメニューORDERボタンの枠線の色
color    position_line_order_button_text_color            = 0x000000;    // ポジションメニューORDERボタンの文字色

// ポジションメニュー
color    position_common_ColorBackground              = C'244,244,244';     // ポジションメニューの内側の背景の色
color    position_common_ColorBorder                  = C'216,216,216';     // ポジションメニューの内側の枠の色
color    position_menu_active_ColorBackground         = C'98,193,251';     // ポジションメニューの選択行の背景の色
color    position_menu_close_ColorBackground          = C'244,244,244';     // ポジションメニューの閉じるの背景の色
color    position_menu_close_ColorBackground_active   = C'255,77,77';     // ポジションメニューの閉じるの背景の色
color    position_menu_close_ColorBorder              = C'106,106,106';     // ポジションメニューの閉じるの枠の色

//////////////////////////////////////////////////////////////////////////////////////////////////////
int      CAPTION_LEFT               = 0;
int      CAPTION_TOP                = 0;
//////////////////////////////////////////////////////////////////////////////////////////////////////
#include <Controls\Dialog.mqh>
#include <Controls\Picture.mqh>
#include <Controls\Button.mqh>
#include <Controls\Label.mqh>
#include <Controls\ComboBox.mqh>
#include "Controls\ControlEx.mqh"

#include <Trade\SymbolInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+

#define CAPTION_NAME                         "トレンドライン注文設定"

//---
#define DIALOG_WIDTH                        (350)
#define DIALOG_HEIGHT                       (225)
//--- indents and gaps
#define INDENT_LEFT                         (11)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (11)      // indent from top (with allowance for border width)
#define INDENT_RIGHT                        (11)      // indent from right (with allowance for border width)
#define INDENT_BOTTOM                       (11)      // indent from bottom (with allowance for border width)
#define CONTROLS_GAP_X                      (5)       // gap by X coordinate
#define CONTROLS_GAP_X_XL                   (20)      // gap by X coordinate
#define CONTROLS_GAP_Y                      (5)       // gap by Y coordinate
#define CONTROLS_GAP_Y_XL                   (20)      // gap by X coordinate
//--- for buttons
#define BUTTON_WIDTH                        (70)      // size by X coordinate
#define BUTTON_WIDTH_XS                     (50)      // size by X coordinate
#define BUTTON_WIDTH_XL                     (100)     // size by X coordinate
#define BUTTON_HEIGHT                       (25)      // size by Y coordinate

#define BMPBUTTON_WIDTH                     (20)
#define BMPBUTTON_HEIGHT                    (30)
//--- for the indication area
#define EDIT_WIDTH                          (60)      // size by Y coordinate
#define EDIT_WIDTH_3XL                      (215)     // size by Y coordinate
#define EDIT_HEIGHT                         (20)      // size by Y coordinate
//--- for group controls
#define GROUP_WIDTH                         (150)     // size by X coordinate
#define LIST_HEIGHT                         (179)     // size by Y coordinate
#define RADIO_HEIGHT                        (56)      // size by Y coordinate
#define CHECK_HEIGHT                        (93)      // size by Y coordinate

#define PANEL_WIDTH                         (90)
#define PANEL_HEIGTH                        (90)
#define PANEL_HEIGTH_XL                     (200)

#define LABEL_WIDTH                         (50)
#define LABEL_WIDTH_XL                      (100)
#define LABEL_WIDTH_2XL                     (150)
#define LABEL_WIDTH_3XL                     (200)
#define LABEL_HEIGHT                        (20)
#define LABEL_HEIGHT_XS                     (10)
#define LABEL_HEIGHT_XL                     (20)

#define POSITION_LABEL1_WIDTH               (20)
#define POSITION_LABEL2_WIDTH               (170)
#define POSITION_LABEL_HEIGHT               (16)

//--- position labels
#define POSITION_EDIT1_WIDTH               (30)
#define POSITION_EDIT1_HEIGHT              (16)
#define POSITION_EDIT2_WIDTH               (170)
#define POSITION_EDIT2_HEIGHT              (16)


#define POSITION_MENU_MAIN_WIDTH      		150               // ポジションメニューのサイズ（左パネルの横幅）
#define POSITION_MENU_MAIN_HEIGHT     		30                // ポジションメニューのサイズ（左パネルの１行の高さ）
#define POSITION_MENU_SUB_WIDTH       		150               // ポジションメニューのサイズ（右パネルの横幅）
#define POSITION_MENU_SUB_HEIGHT_01   		60                // ポジションメニューのサイズ（右パネルの%クローズの時の高さ）
#define POSITION_MENU_SUB_HEIGHT_02   		90                // ポジションメニューのサイズ（右パネルのTP,SL設定の時の高さ）
#define POSITION_MENU_CLOSE_WIDTH     		30                // ポジションメニューのサイズ（閉じるボタン）
#define POSITION_MENU_CLOSE_HEIGHT    		30                // ポジションメニューのサイズ（閉じるボタン）
#define POSITION_MENU_SUB_ROW_INDENT		5		  // ポジションメニューのサイズ（右パネルのobject余白）
#define POSITION_MENU_SUB_COL_INDENT		5		  // ポジションメニューのサイズ（右パネルのobject余白）
#define POSITION_MENU_SUB_LABEL_WIDTH		50		  // ポジションメニューのサイズ（右パネルのTPSLラベルの横幅）
#define POSITION_MENU_SUB_LABEL_HEIGHT		20		  // ポジションメニューのサイズ（右パネルのTPSLラベルの横幅）
#define POSITION_MENU_SUB_EDIT_WIDTH		70		  // ポジションメニューのサイズ（右パネルの入力の横幅）
#define POSITION_MENU_SUB_EDIT_HEIGHT		20		  // ポジションメニューのサイズ（右パネルの入力の高さ）
#define POSITION_MENU_SUB_BUTTON_WIDTH		30		  // ポジションメニューのサイズ（右パネルのボタンの横幅）
#define POSITION_MENU_SUB_BUTTON_HEIGHT		20		  // ポジションメニューのサイズ（右パネルのボタンの高さ）

//---
#define GV_SAL_DIALOG_AXISX            "gv.sal_dialog_axisX"
#define GV_SAL_DIALOG_AXISY            "gv.sal_dialog_axisY"

#define LABEL_ODR_TEXT_NAME_PREFIX     "sal_odr_"
#define LABEL_ODR_STATE_NAME_PREFIX    "sal_odr_state_"

#define OBJ_NAME_PREFIX                "sal_"

#define HLINE_ENTRY_NAME               "sal_hline_entry"
#define HLINE_TP_NAME                  "sal_hline_tp"
#define HLINE_SL_NAME                  "sal_hline_sl"

#define LABEL_ENTRY_NAME               "sal_label_entry"
#define LABEL_TP_NAME                  "sal_label_tp"
#define LABEL_SL_NAME                  "sal_label_sl"

#define LABEL_CANDLETIME_NAME          "sal_label_candletime"
#define LABEL_MA_TPSL_INFO_NAME        "sal_label_tpsl_info"
#define LABEL_TRAILINGSTOP_INFO_NAME   "sal_label_trailingstop_info"

//--- ポジション操作メニューObject名
#define POSITION_MENU_NAME_PREFIX      "sal_position_menu_"
//--- ポジションごとのボタンObject名
#define POSITION_NAME_PREFIX           "sal_position_"
#define POSITION_TP_NAME_PREFIX        "sal_position_tp_"
#define POSITION_SL_NAME_PREFIX        "sal_position_sl_"
#define POSITION_ORDER_NAME_PREFIX     "sal_order_"

#define BUY_TOUCH          "Buy Touch"
#define SELL_TOUCH         "Sell Touch"
#define BUY_BREAKOUT       "Buy Breakout"
#define SELL_BREAKOUT      "Sell Breakout"
#define BUY_PULLBACK       "Buy Pullback"
#define SELL_PULLBACK      "Sell Pullback"
#define BUY_ROLE_REVERSAL  "Buy Role Reversal"
#define SELL_ROLE_REVERSAL "Sell Role Reversal"

#define NAN          (int)-99999999999
     
         
enum ENUM_TL_ORDER_TYPE
{
   BuyTouch,
   SellTouch,
   BuyBreakout,
   SellBreakout,
   BuyPullback,
   SellPullback,
   BuyRoleReversal,
   SellRoleReversal
};

struct CTrendlineStrategy
  {
   public:
      CTrendlineStrategy(void)
         : m_OrderType(BuyTouch)
         , m_Lots(0)
         , m_TP_in_Pips(0)
         , m_SL_in_Pips(0)
         , m_Alert(false)
         , m_startTime(0)
         , m_executed(false)
         , m_brktFlg(false)
         , m_brktTime(0)
         , m_pbFlg(false)
         , m_pbTime(0)
         , m_pbSwingHLPrice(EMPTY_VALUE)
        {
        }
        
     ~CTrendlineStrategy(void) {}
   
      char                 m_LineId[255];
      ENUM_TL_ORDER_TYPE   m_OrderType;
      double               m_Lots;
      double               m_TP_in_Pips;
      double               m_SL_in_Pips;
      bool                 m_Alert;
      datetime             m_startTime;
      
      bool                 m_executed;    // order executed flag
      
      bool                 m_brktFlg;     // breakout flag
      datetime             m_brktTime;    // breakout time      
      bool                 m_pbFlg;       // pullback flag
      datetime             m_pbTime;      // pullback time
      double               m_pbSwingHLPrice; // swing high/low between breakout and pullback     
  };

input ENUM_TL_ORDER_TYPE   InpDefaultOrderType=BuyTouch; // デフォルト注文方法
input double               InpDefaultLotSize=0.1; // デフォルトロットサイズ
double               InpDefaultTP_Pips=0;
double               InpDefaultSL_Pips=0;
input bool                 InpDefaultAlertFlag=true; // デフォルトでアラートをONにする
input string               InpTrendlineHotkey="T"; // トレンドラインのショートカットキー
input color                InpTrendlineColor=clrRed; // トレンドラインの色
input int                  InpTrendlineWidth=2; // トレンドラインの太さ
input string               InpHorizonlineHotkey="H"; // 水平線のショートカットキー
input color                InpHorizonlineColor=clrYellow; // 水平線の色
input int                  InpHorizonlineWidth=2; // 水平線の太さ
input bool                 InpChkBreakoutOnBarClose=false; // break注文のブレイク判定を足確定まで待つ
input bool                 InpMAStopOnBarClose=false; // MA決済注文のブレイク判定を足確定まで待つ
input int                  InpMATPSLInfo_FontSize=10;
input color                InpMATPSLInfo_FontColor=clrRed;
input int                  InpTrailingStopInfo_FontSize=10;
input color                InpTrailingStopInfo_FontColor=clrRed;

CTrendlineStrategy   _trlineStrategies[];

// ポジション制御のため
ulong position_tickets[];
ulong position_tps[];
ulong position_sls[];
ulong order_tickets[];
int   position_label_ys[];
int open_menu_position_ticket;

struct CPositionTrailingStopSet
  {
   CPositionTrailingStopSet()
      : ticket(-1)
      , targetPips(0)
     {}
      
   ulong    ticket;
   double   targetPips;
  };
  
struct CPositionMAStopSet
  {
   CPositionMAStopSet()
      : ticket(-1)
      , timeframe(0)
      , maTpFlg(false)
      , maTpPeriod(0)
      , maTpMethod(0)
      , maSlFlg(false)
      , maSlPeriod(0)
      , maSlMethod(0)
     {}
     
   ulong             ticket;
   ENUM_TIMEFRAMES   timeframe;
   bool              maTpFlg;
   int               maTpPeriod;
   ENUM_MA_METHOD    maTpMethod;
   bool              maSlFlg;
   int               maSlPeriod;
   ENUM_MA_METHOD    maSlMethod;
  };

CPositionTrailingStopSet   _positionTrailingStopSets[];
CPositionMAStopSet         _positionMAStopSets[];
  
// 許可口座一覧
bool accountControlEnable = false;
int accountList[] = {
};

int _lotdigits=0;
//+------------------------------------------------------------------+
//| Class CSettingsDialog                                        |
//| Usage: main dialog of the Controls application                   |
//+------------------------------------------------------------------+
class CSettingsDialog : public CAppDialog
  {
protected:
   CSymbolInfo       m_symbolInfo;   
   CPositionInfo     m_positionInfo;                     // trade position object
   COrderInfo        m_orderInfo;                        // trade order object
   CTrade            m_trade;                            // trading object
   CAccountInfo      m_accountInfo;                      // account info wrapper
     
private:
   CPanel            m_panel_Border;
   CPanel            m_panel_Back;
   CWndClient        m_wnd_Client;
   CEdit             m_label_Caption;
   CBmpButton        m_button_MinMax;
   CBmpButton        m_button_Close;

   //---
   CPanel            m_panel_MainPanel;
   
   CLabel            m_label_OrderType;
   CLabel            m_label_LotSize;
   CLabel            m_label_Takeprofit;
   CLabel            m_label_Stoploss;
   CLabel            m_label_Alert;
   
   CComboBox         m_combox_OrderType;
   
   CSpinEditEx       m_spin_LotSize;
   CSpinEditEx       m_spin_Takeprofit;
   CSpinEditEx       m_spin_Stoploss;
   
   CCheckBoxEx       m_chkbox_Alert;   

   CButton           m_button_Horizon;
   CButton           m_button_MA;
   
   CButton           m_button_Set;
   CButton           m_button_CloseBuy;
   CButton           m_button_CloseSell;
   CButton           m_button_CloseAll;
   CButton           m_button_DeleteAllLines;
//---
   CPanel            m_position_menu_main_panel;
   CPanel            m_position_menu_sub_panel;
   CPanel            m_position_menu_main_exit_panel;
   CPanel            m_position_menu_main_doten_panel;
   CPanel            m_position_menu_main_percent_exit_menu_panel;
   CPanel            m_position_menu_main_sltatene_panel;
   CPanel            m_position_menu_main_trailingstop_menu_panel;
   CPanel            m_position_menu_main_tpsl_menu_panel;
   CPanel            m_position_menu_main_ma_tpsl_menu_panel;
   CButton           m_position_menu_main_close;
   CLabel            m_position_menu_main_exit;
   CLabel            m_position_menu_main_doten;
   CLabel            m_position_menu_main_percent_exit_menu;
   CLabel            m_position_menu_main_sltatene;
   CLabel            m_position_menu_main_trailingstop_menu;
   CLabel            m_position_menu_main_tpsl_menu;
   CLabel            m_position_menu_main_ma_tpsl_menu;
   CLabel            m_position_menu_main_percent_label;
   CEdit             m_position_menu_main_percent_input;
   CButton           m_position_menu_main_percent_exit;
   CCheckBoxEx       m_position_menu_sub_trailingstop_chk;
   CEdit             m_position_menu_sub_trailingstop_targetpips;
   CButton           m_position_menu_sub_trailingstop_set;
   CLabel            m_position_menu_main_tp_label;
   CLabel            m_position_menu_main_sl_label;
   CEdit             m_position_menu_main_tpsl_tp_input;
   CEdit             m_position_menu_main_tpsl_sl_input;
   CButton           m_position_menu_main_tpsl_set;   
   CCheckBoxEx       m_position_menu_sub_ma_tp_chk;
   CCheckBoxEx       m_position_menu_sub_ma_sl_chk;
   CComboBoxEx       m_position_menu_sub_ma_tp_method;
   CComboBoxEx       m_position_menu_sub_ma_sl_method;
   CEdit             m_position_menu_sub_ma_tp_period;
   CEdit             m_position_menu_sub_ma_sl_period;
   CButton           m_position_menu_sub_ma_tpsl_set;
   
public:
                     CSettingsDialog(void);
                    ~CSettingsDialog(void);
   //--- create
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   virtual void      Destroy(const int reason=REASON_PROGRAM);
   
   virtual void      Minimize(void) {};
   virtual void      Maximize(void) {};
   virtual bool      Show(void);
   virtual bool      Hide(void);
   
   //--- chart event handler
   virtual void      OnClickButtonClose(void);
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   
   void              OnCreateSRLine(string lineObjName);
   void              OnDeleteSRLine(string lineObjName);
   void              OnSelectSRLine(string lineObjName);
   void              OnDeselectSRLine(string lineObjName, bool autoUnselect=true);
   void              OnChangeSRLine(string lineObjName);
   void              OnMoveStopLine(string stoplineObjName);
   void              OnMoveEntryLine();
   
//--- ポジションメニューイベント
   void              OnPositionMenuClose(void);
   void              OnPositionMenuExit(void);
   void              OnPositionMenuDoten(void);
   void              OnPositionMenuPercentMenu(void);   
   void              OnPositionMenuSlTatene(void);   
   void              OnPositionMenuTrailingStopMenu(void);
   void              OnPositionMenuTpSlMenu(void);
   void              OnPositionMenuMATpSlMenu(void);
   void              OnPositionMenuExitExec(void);
   void              OnPositionMenuTpSlExec(void);
   
   void              OnPositionMenuTrailingStopSet(void);
   void              OnPositionMenuMATpSlCheck(string tpSlObjName);
   void              OnPositionMenuMATpSlMethod(string tpSlObjName);
   void              OnPositionMenuMATpSlSet();
   
   void              OnTick();
   void              OnCalculateStrategy();
   void              OnCalculateMAStop();
   void              OnCalculateTrailingStop();
   
   string            GetSelectedSRLineName();
   string            GetDefaultOdrText();
   string            GetCurrentOdrText();
   
   void              OnClickButton_CloseBuy();
   void              OnClickButton_CloseSell();
   void              OnClickButton_CloseAll();
protected:
   //--- create dependent controls
   bool              CreateCLabel(CLabel &obj, string name, string text, string font, int font_size, color font_color, int w, int h, ENUM_ANCHOR_POINT align, int angle = 0);
   bool              CreateCButton(CButton &obj, string name, string text, string font, int font_size, color font_color, color bg_color, color border_color, int w, int h, ENUM_ALIGN_MODE align);
   bool              CreateCEdit(CEdit &obj, string name, string text, string font, int font_size, color font_color, color bg_color, int w, int h, ENUM_ALIGN_MODE align, bool read_only = false);
   bool              CreateCPanel(CPanel &obj, string name, color borderColor, color bgColor, int w, int h);
   bool              CreateCBitmap(CBmpButton &obj, string name, int w, int h, ENUM_ANCHOR_POINT anchor, string onBmpName, string offBmpName);
   bool              CreateCSpinEdit(CSpinEditEx &obj, string name, int w, int h, bool checkable = false, string suffix = "");
   bool              CreateCCombobox(CComboBox &obj, string name, int w, int h);
   bool              CreateCCheckBox(CCheckBoxEx &obj, string name, int w, int h, bool noLabelFlag=false);
   bool              CreateCCheckBox(CCheckBoxEx &obj, string name, string text, string font, int font_size, color font_color, int w, int h, bool noLabelFlag=false);

   bool              InitObj(void);
   void              MoveObj(void);
   
   bool              CreateStoplinesObj();
   bool              CreateCandletimeObj();
   bool              CreateStopLevelsInfoObj();
   
   bool              HideAll(string prefix);
   //--- handlers of the dependent controls events
   virtual bool      OnDialogDragProcess();
   virtual bool      OnDialogDragEnd();
   
   void              OnClickButton_Set();
   void              OnClickButton_DeleteAllLines();
   
   void              OnChangeCombox_OrderType();
   void              OnChangeSpinEdit_Takeprofit();
   void              OnChangeSpinEdit_Stoploss();
   
   void              AddOrModifyStrategy(string lineObjName);
   void              RemoveStrategy(string lineObjName);
   void              RemoveAllStrategy();
   
   //---
   virtual bool  CreateAndUpdatePositionObjects();
   virtual bool  CreatePositionObject(ulong tickt);
   virtual bool  CreatePositionTpObject(ulong tickt);
   virtual bool  CreatePositionSlObject(ulong tickt);
   virtual bool  CreateOrderObject(ulong tickt);
   virtual bool  DeletePositionObject(ulong tickt);
   virtual bool  DeletePositionTpObject(ulong tickt);
   virtual bool  DeletePositionSlObject(ulong tickt);
   virtual bool  DeleteOrderObject(ulong tickt);
   virtual bool  MovePositionObject(ulong tickt);
   virtual bool  MovePositionTpObject(ulong tickt);
   virtual bool  MovePositionSlObject(ulong tickt);
   virtual bool  MoveOrderObject(ulong tickt);

public:   
   virtual bool  CreatePositionMenu(int x, int y, string sparam);
   virtual bool  RemovePositionTp(int x, int y, string sparam);
   virtual bool  RemovePositionSl(int x, int y, string sparam);
   virtual bool  RemoveOrder(int x, int y, string sparam);
   virtual bool  ChkOnMouse(int x, int y, string sparam);
   
   bool  RefreshControls();
   void  AdjustStoplineLabelsXY();
  };
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CSettingsDialog)
ON_EVENT(ON_CLICK,m_button_Set,OnClickButton_Set)
ON_EVENT(ON_CLICK,m_button_CloseBuy,OnClickButton_CloseBuy)
ON_EVENT(ON_CLICK,m_button_CloseSell,OnClickButton_CloseSell)
ON_EVENT(ON_CLICK,m_button_CloseAll,OnClickButton_CloseAll)
ON_EVENT(ON_CLICK,m_button_DeleteAllLines,OnClickButton_DeleteAllLines)
ON_EVENT(ON_CHANGE,m_combox_OrderType,OnChangeCombox_OrderType)
ON_EVENT(ON_CHANGE,m_spin_Takeprofit,OnChangeSpinEdit_Takeprofit)
ON_EVENT(ON_CHANGE,m_spin_Stoploss,OnChangeSpinEdit_Stoploss)
EVENT_MAP_END(CAppDialog)
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSettingsDialog::CSettingsDialog(void)
  {
   m_symbolInfo.Refresh();
   
   for(int i=0;i<ObjectsTotal(0);i++)
     {
      string objName=ObjectName(0,i);
      if(ObjectGetInteger(0,objName,OBJPROP_TYPE)==OBJ_TEXT &&
         StringFind(objName,LABEL_ODR_STATE_NAME_PREFIX)!=-1)
        {
         ObjectSetInteger(0,objName,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
        }
     }
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSettingsDialog::~CSettingsDialog(void)
  {
  }
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool CSettingsDialog::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
//---
   int controlsTotal = ExtDialog.ControlsTotal();
   for(int i=0; i<controlsTotal; i++)
     {
      CWnd*obj=ExtDialog.Control(i);
      string objName=obj.Name();

      if(StringFind(objName,"Client")>0)
        {
         CWndClient *obj2=(CWndClient*)obj;
         m_wnd_Client = obj2;
        }
      else if(StringFind(objName,"Back")>0)
        {
         CPanel *obj2=(CPanel*)obj;
         m_panel_Back = obj2;
        }
      else if(StringFind(objName,"Border")>0)
        {
         CPanel *obj2=(CPanel*)obj;
         m_panel_Border = obj2;
        }
      else if(StringFind(objName,"Caption")>0)
        {
         CEdit *obj2=(CEdit*)obj;
         m_label_Caption = obj2;
        }
      else if(StringFind(objName,"MinMax")>0)
        {
         CBmpButton *obj2=(CBmpButton*)obj;
         m_button_MinMax = obj2;
        }
      else if(StringFind(objName,"Close")>0)
        {
         CBmpButton *obj2=(CBmpButton*)obj;
         m_button_Close = obj2;
        }
     }
//--- create dependent controls
   if(!InitObj())
      return(false);
//---
   if(!CreateStoplinesObj())
      return(false);
   if(!CreateCandletimeObj())
      return(false);
   if(!CreateStopLevelsInfoObj())
      return(false);   
//---
   MoveObj();   
   Hide(); 
//--- succeed
   return(true);
  }

void CSettingsDialog::Destroy(const int reason)
  {
   if(reason==REASON_PROGRAM || reason==REASON_REMOVE)
     {
      OnClickButton_DeleteAllLines();
     }

   ArrayResize(position_tickets,0);  
   ArrayResize(position_tps,0);
   ArrayResize(position_sls,0);
   ArrayResize(position_label_ys,0);
   
   CAppDialog::Destroy(reason);
  }
   
void CSettingsDialog::OnClickButtonClose(void)
  {
   Hide();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSettingsDialog::Show(void)
{
   CAppDialog::Show();
   
   m_button_MinMax.Hide();
   //m_button_Close.Hide(); 
   
   string lineObjName=GetSelectedSRLineName();
   if(lineObjName!="")
     {
      ENUM_OBJECT objType=(ENUM_OBJECT)ObjectGetInteger(0,lineObjName,OBJPROP_TYPE);
      ObjectSetInteger(0,lineObjName,OBJPROP_WIDTH,(objType==OBJ_TREND ? InpTrendlineWidth : InpHorizonlineWidth)+1);
      ObjectSetInteger(0,lineObjName,OBJPROP_SELECTED,true);
      
      bool tplineEdit=m_spin_Takeprofit.Checked();
      bool sllineEdit=m_spin_Stoploss.Checked();
      ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_TIMEFRAMES, tplineEdit ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_TIMEFRAMES, tplineEdit ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
      ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_TIMEFRAMES, sllineEdit ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_TIMEFRAMES, sllineEdit ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
     }
     
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSettingsDialog::Hide(void)
{
   CAppDialog::Hide();
      
   string lineObjName=GetSelectedSRLineName();
   if(lineObjName!="")
     {
      ENUM_OBJECT objType=(ENUM_OBJECT)ObjectGetInteger(0,lineObjName,OBJPROP_TYPE);
      
      ObjectSetInteger(0,lineObjName,OBJPROP_WIDTH,objType==OBJ_TREND ? InpTrendlineWidth : InpHorizonlineWidth);
      ObjectSetInteger(0,lineObjName,OBJPROP_SELECTED,false);
     }
   
   ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);        
   ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
         
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSettingsDialog::OnTick(void)
  {
   m_symbolInfo.Refresh();
   m_symbolInfo.RefreshRates();
   
   OnCalculateStrategy();
   OnCalculateMAStop();
   OnCalculateTrailingStop();
  }
  
void CSettingsDialog::OnCalculateStrategy(void)
  {
//---
   int trlineStrategiesTotal=ArraySize(_trlineStrategies);
   
   //Comment(trlineStrategiesTotal);
   
   for(int i=0;i<trlineStrategiesTotal;i++)
     {
      if(!_trlineStrategies[i].m_executed)
        {
         string lineObjName=CharArrayToString(_trlineStrategies[i].m_LineId);
         double trlinePrice2=GetPriceBySRLine(lineObjName,iTime(NULL,0,2));
         double trlinePrice1=GetPriceBySRLine(lineObjName,iTime(NULL,0,1));
         double trlinePrice0=GetPriceBySRLine(lineObjName);
         
         ENUM_TL_ORDER_TYPE odrType=_trlineStrategies[i].m_OrderType;
         double lots=_trlineStrategies[i].m_Lots;
         double slPips=_trlineStrategies[i].m_SL_in_Pips;
         double tpPips=_trlineStrategies[i].m_TP_in_Pips;
         bool   alertFlg=_trlineStrategies[i].m_Alert;
         
         bool   executed=false;
         
         double askPrice=SymbolInfoDouble(NULL,SYMBOL_ASK);
         double bidPrice=SymbolInfoDouble(NULL,SYMBOL_BID);
                     
         switch(odrType)
           {
            case BuyTouch:
            case SellBreakout:
              {
               int barIndex= odrType==BuyTouch ? 0 : (InpChkBreakoutOnBarClose ? 1 : 0);
               
               if(MathMin(iOpen(NULL,0,barIndex+1),iClose(NULL,0,barIndex+1))>trlinePrice1 && iClose(NULL,0,barIndex)<=trlinePrice0 &&
                  iTime(NULL,0,barIndex)>=_trlineStrategies[i].m_startTime)
                 {
                  double slPrice= slPips==0 ? 0 : (odrType==BuyTouch ? askPrice-slPips*_Pips : bidPrice+slPips*_Pips);
                  double tpPrice= tpPips==0 ? 0 : (odrType==BuyTouch ? askPrice+tpPips*_Pips : bidPrice-tpPips*_Pips);
                  string comment= odrType==BuyTouch ? "b.t" : "s.brkt";
                  
                  executed= odrType==BuyTouch ? m_trade.Buy(lots,NULL,0,slPrice,tpPrice,comment) : m_trade.Sell(lots,NULL,0,slPrice,tpPrice,comment);
                  
                  if(alertFlg)
                    {
                     Alert(lineObjName+": ",EnumTLOrderTypeToString(odrType),", Lots ",lots, ", Entry ",DoubleToString(odrType==BuyTouch ? askPrice : bidPrice,_Digits), ", SL ",DoubleToString(slPrice,_Digits), ", TP ",DoubleToString(tpPrice,_Digits));
                    }
                 }
               break;
              }
            case SellTouch:
            case BuyBreakout:
              {
               int barIndex= odrType==SellTouch ? 0 : (InpChkBreakoutOnBarClose ? 1 : 0);
               
               if(MathMax(iOpen(NULL,0,barIndex+1),iClose(NULL,0,barIndex+1))<trlinePrice1 && iClose(NULL,0,barIndex)>=trlinePrice0 &&
                  iTime(NULL,0,barIndex)>=_trlineStrategies[i].m_startTime)
                 {
                  double slPrice= slPips==0 ? 0 : (odrType==SellTouch ? bidPrice+slPips*_Pips : askPrice-slPips*_Pips);
                  double tpPrice= tpPips==0 ? 0 : (odrType==SellTouch ? bidPrice-tpPips*_Pips : askPrice+tpPips*_Pips);
                  string comment= odrType==BuyTouch ? "s.t" : "b.brkt";
                  
                  executed= odrType==SellTouch ? m_trade.Sell(lots,NULL,0,slPrice,tpPrice,comment) : m_trade.Buy(lots,NULL,0,slPrice,tpPrice,comment);
                  
                  if(alertFlg)
                    {
                     Alert(lineObjName+": ",EnumTLOrderTypeToString(odrType),", Lots ",lots, ", Entry ",DoubleToString(odrType==SellTouch ? bidPrice : askPrice,_Digits), ", SL ",DoubleToString(slPrice,_Digits), ", TP ",DoubleToString(tpPrice,_Digits));
                    }
                 }
               break;
              }
            case BuyPullback:
              {
               if(iClose(NULL,0,2)<trlinePrice2 && iClose(NULL,0,1)>=trlinePrice1 &&
                  iTime(NULL,0,1)>_trlineStrategies[i].m_startTime)
                 {
                  if(!_trlineStrategies[i].m_brktFlg)
                    {
                     _trlineStrategies[i].m_brktFlg=true;
                    }
                 }
                 
               if(_trlineStrategies[i].m_brktFlg)
                 {
                  if(iClose(NULL,0,1)>trlinePrice1 && iClose(NULL,0,0)<=trlinePrice0)
                    {                     
                     double slPrice= slPips==0 ? 0 : (askPrice-slPips*_Pips);
                     double tpPrice= tpPips==0 ? 0 : (askPrice+tpPips*_Pips);
                     string comment= "b.pb";
                     
                     executed=m_trade.Buy(lots,NULL,0,slPrice,tpPrice,comment);
                     
                     if(alertFlg)
                       {
                        Alert(lineObjName+": ",EnumTLOrderTypeToString(odrType),", Lots ",lots, ", Entry ",DoubleToString(askPrice,_Digits), ", SL ",DoubleToString(slPrice,_Digits), ", TP ",DoubleToString(tpPrice,_Digits));
                       }
                    }
                 } 
               break;
              }
            case SellPullback:
              {
               if(iClose(NULL,0,2)>trlinePrice2 && iClose(NULL,0,1)<=trlinePrice1 &&
                  iTime(NULL,0,1)>_trlineStrategies[i].m_startTime)
                 {
                  if(!_trlineStrategies[i].m_brktFlg)
                    {
                     _trlineStrategies[i].m_brktFlg=true;
                    }
                 }
                 
               if(_trlineStrategies[i].m_brktFlg)
                 {
                  if(iClose(NULL,0,1)<trlinePrice1 && iClose(NULL,0,0)>=trlinePrice0)
                    {
                     double slPrice= slPips==0 ? 0 : (bidPrice+slPips*_Pips);
                     double tpPrice= tpPips==0 ? 0 : (bidPrice-tpPips*_Pips);
                     string comment= "s.pb";
                     
                     executed=m_trade.Sell(lots,NULL,0,slPrice,tpPrice,comment);
                     
                     if(alertFlg)
                       {
                        Alert(lineObjName+": ",EnumTLOrderTypeToString(odrType),", Lots ",lots, ", Entry ",DoubleToString(askPrice,_Digits), ", SL ",DoubleToString(slPrice,_Digits), ", TP ",DoubleToString(tpPrice,_Digits));
                       }
                    }
                 }
               break;
              }
            case BuyRoleReversal:
              {
               if(iClose(NULL,0,2)<trlinePrice2 && iClose(NULL,0,1)>=trlinePrice1 &&
                  iTime(NULL,0,1)>_trlineStrategies[i].m_startTime)
                 {
                  if(!_trlineStrategies[i].m_brktFlg)
                    {
                     _trlineStrategies[i].m_brktFlg=true;
                     _trlineStrategies[i].m_brktTime=iTime(NULL,0,1);
                    }
                 }
                 
               if(_trlineStrategies[i].m_brktFlg)
                 {
                  if(iClose(NULL,0,1)>trlinePrice1 && iClose(NULL,0,0)<=trlinePrice0)
                    {
                     int brktPos=iBarShift(NULL,0,_trlineStrategies[i].m_brktTime,true);
                     if(brktPos==-1)   return;
                     
                     if(!_trlineStrategies[i].m_pbFlg)
                       {
                        _trlineStrategies[i].m_pbFlg=true;
                        _trlineStrategies[i].m_pbTime=iTime(NULL,0,0);                     
                        _trlineStrategies[i].m_pbSwingHLPrice=iHigh(NULL,0,iHighest(NULL,0,MODE_HIGH,brktPos+1,0));
                       }
                    }
                 } 
                 
               if(_trlineStrategies[i].m_pbFlg)
                 {
                  if(iClose(NULL,0,0)>_trlineStrategies[i].m_pbSwingHLPrice)
                    {
                     double slPrice= slPips==0 ? 0 : (askPrice-slPips*_Pips);
                     double tpPrice= tpPips==0 ? 0 : (askPrice+tpPips*_Pips);
                     string comment= "b.rr";
                     
                     executed=m_trade.Buy(lots,NULL,0,slPrice,tpPrice,comment);
                     
                     if(alertFlg)
                       {
                        Alert(lineObjName+": ",EnumTLOrderTypeToString(odrType),", Lots ",lots, ", Entry ",DoubleToString(askPrice,_Digits), ", SL ",DoubleToString(slPrice,_Digits), ", TP ",DoubleToString(tpPrice,_Digits));
                       }
                    }
                 }  
               break;
              }
            case SellRoleReversal:
              {
               if(iClose(NULL,0,2)>trlinePrice2 && iClose(NULL,0,1)<=trlinePrice1 &&
                  iTime(NULL,0,1)>_trlineStrategies[i].m_startTime)
                 {
                  if(!_trlineStrategies[i].m_brktFlg)
                    {
                     _trlineStrategies[i].m_brktFlg=true;
                     _trlineStrategies[i].m_brktTime=iTime(NULL,0,1);
                    }
                 }
                 
               if(_trlineStrategies[i].m_brktFlg)
                 {
                  if(iClose(NULL,0,1)<trlinePrice1 && iClose(NULL,0,0)>=trlinePrice0)
                    {
                     int brktPos=iBarShift(NULL,0,_trlineStrategies[i].m_brktTime,true);
                     if(brktPos==-1)   return;
                     
                     if(!_trlineStrategies[i].m_pbFlg)
                       {
                        _trlineStrategies[i].m_pbFlg=true;
                        _trlineStrategies[i].m_pbTime=iTime(NULL,0,0);                     
                        _trlineStrategies[i].m_pbSwingHLPrice=iLow(NULL,0,iLowest(NULL,0,MODE_LOW,brktPos+1,0));  
                       }
                    }
                 }
                 
               if(_trlineStrategies[i].m_pbFlg)
                 {
                  if(iClose(NULL,0,0)<_trlineStrategies[i].m_pbSwingHLPrice)
                    {
                     double slPrice= slPips==0 ? 0 : (bidPrice+slPips*_Pips);
                     double tpPrice= tpPips==0 ? 0 : (bidPrice-tpPips*_Pips);
                     string comment= "s.rr";
                     
                     executed=m_trade.Sell(lots,NULL,0,slPrice,tpPrice,comment);
                     
                     if(alertFlg)
                       {
                        Alert(lineObjName+": ",EnumTLOrderTypeToString(odrType),", Lots ",lots, ", Entry ",DoubleToString(bidPrice,_Digits), ", SL ",DoubleToString(slPrice,_Digits), ", TP ",DoubleToString(tpPrice,_Digits));
                       }
                    }
                 }
               break;
              }    
            default:
              break;
           }
         
         if(executed)
           {
            ObjectSetInteger(0,lineObjName,OBJPROP_COLOR,clrGray);
            ObjectSetString(0,lineObjName,OBJPROP_TEXT,IntegerToString(m_trade.ResultOrder()));
            ObjectSetInteger(0,LABEL_ODR_TEXT_NAME_PREFIX+lineObjName,OBJPROP_COLOR,clrGray);
            ObjectSetInteger(0,LABEL_ODR_STATE_NAME_PREFIX+lineObjName,OBJPROP_COLOR,clrGray);
            
            _trlineStrategies[i].m_executed=executed;
           }  
        }
     }
     
   for(int i=trlineStrategiesTotal-1;i>=0;i--)
     {
      if(_trlineStrategies[i].m_executed)
         RemoveStrategy(CharArrayToString(_trlineStrategies[i].m_LineId));
     }  
  }

void CSettingsDialog::OnCalculateMAStop()
  {   
   for(int i=ArraySize(_positionMAStopSets)-1;i>=0;i--)
     {
      if(!m_positionInfo.SelectByTicket(_positionMAStopSets[i].ticket))
        {
         ArrayRemove(_positionMAStopSets,i,1);
         continue; 
        }
      
      if(m_positionInfo.TakeProfit()>0)
        {
         _positionMAStopSets[i].maTpFlg=false;
        }
      if(m_positionInfo.StopLoss()>0)
        {
         _positionMAStopSets[i].maSlFlg=false;
        }
          
      if(_positionMAStopSets[i].maTpFlg)
        {
         int handle=FirstOrCreateMAIndicator(_positionMAStopSets[i].timeframe,_positionMAStopSets[i].maTpPeriod,_positionMAStopSets[i].maTpMethod);
         if(handle!=INVALID_HANDLE)
           {
            double ma[2];
            double close[2];
            
            close[0]=InpMAStopOnBarClose?iClose(_Symbol,_positionMAStopSets[i].timeframe,1):iClose(_Symbol,_positionMAStopSets[i].timeframe,0);
            close[1]=InpMAStopOnBarClose?iClose(_Symbol,_positionMAStopSets[i].timeframe,2):iClose(_Symbol,_positionMAStopSets[i].timeframe,1);
            
            ResetLastError();
            if(CopyBuffer(handle,0,InpMAStopOnBarClose?1:0,2,ma)==2)
              {
               if((m_positionInfo.PositionType()==POSITION_TYPE_BUY && close[1]<ma[1] && close[0]>=ma[0]) ||
                  (m_positionInfo.PositionType()==POSITION_TYPE_SELL && close[1]>ma[1] && close[0]<=ma[0]))
                 {
                  m_trade.PositionClose(_positionMAStopSets[i].ticket);
                 }
              }
            else  
              {
               //--- if the copying fails, tell the error code
               PrintFormat("MA TP: Failed to copy data from the iMA indicator, error code %d",GetLastError());
              }
           }
         else  
           {
            Print("MA TP: Invalid indicator handle!");
           }            
        }
      
      if(_positionMAStopSets[i].maSlFlg)
        {
         int handle=FirstOrCreateMAIndicator(_positionMAStopSets[i].timeframe,_positionMAStopSets[i].maSlPeriod,_positionMAStopSets[i].maSlMethod);
         if(handle!=INVALID_HANDLE)
           {
            double ma[2];
            double close[2];
            
            close[0]=InpMAStopOnBarClose?iClose(_Symbol,_positionMAStopSets[i].timeframe,1):iClose(_Symbol,_positionMAStopSets[i].timeframe,0);
            close[1]=InpMAStopOnBarClose?iClose(_Symbol,_positionMAStopSets[i].timeframe,2):iClose(_Symbol,_positionMAStopSets[i].timeframe,1);
            
            ResetLastError();
            if(CopyBuffer(handle,0,InpMAStopOnBarClose?1:0,2,ma)==2)
              {
               if((m_positionInfo.PositionType()==POSITION_TYPE_BUY && close[1]>ma[1] && close[0]<=ma[0]) ||
                  (m_positionInfo.PositionType()==POSITION_TYPE_SELL && close[1]<ma[1] && close[0]>=ma[0]))
                 {
                  m_trade.PositionClose(_positionMAStopSets[i].ticket);
                 }
              }
            else  
              {
               //--- if the copying fails, tell the error code
               PrintFormat("MA SL: Failed to copy data from the iMA indicator, error code %d",GetLastError());
              }
           }
         else  
           {
            Print("MA SL: Invalid indicator handle!");
           }   
        }
     }
  }
  
void CSettingsDialog::OnCalculateTrailingStop(void)
  {
   m_symbolInfo.RefreshRates();
   
   for(int i=ArraySize(_positionTrailingStopSets)-1;i>=0;i--)
     {
      if(!m_positionInfo.SelectByTicket(_positionTrailingStopSets[i].ticket))
        {
         ArrayRemove(_positionTrailingStopSets,i,1);
         continue; 
        }
       
      double stopPriceLevel=m_symbolInfo.StopsLevel()*_Point;
      double newStopPriceLevel=0;
      
      if(m_positionInfo.PositionType()==POSITION_TYPE_BUY)
        {
         newStopPriceLevel=m_symbolInfo.Bid()-stopPriceLevel;
         if(newStopPriceLevel>m_positionInfo.PriceOpen()+_positionTrailingStopSets[i].targetPips*_Pips && (m_positionInfo.StopLoss()==0 || newStopPriceLevel>m_positionInfo.StopLoss()))
           {
            m_trade.PositionModify(_positionTrailingStopSets[i].ticket,newStopPriceLevel,m_positionInfo.TakeProfit());
           }
        }
      else if(m_positionInfo.PositionType()==POSITION_TYPE_SELL)
        {
         newStopPriceLevel=m_symbolInfo.Ask()+stopPriceLevel;
         if(newStopPriceLevel<m_positionInfo.PriceOpen()-_positionTrailingStopSets[i].targetPips*_Pips && (m_positionInfo.StopLoss()==0 || newStopPriceLevel<m_positionInfo.StopLoss()))
           {
            m_trade.PositionModify(_positionTrailingStopSets[i].ticket,newStopPriceLevel,m_positionInfo.TakeProfit());
           }   
        }
     }
  }  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSettingsDialog::CreateCButton(CButton &obj, string name, string text, string font, int font_size, color font_color, color bg_color, color border_color, int w, int h, ENUM_ALIGN_MODE align)
  {
   if(!obj.Create(0,name,0,
                  0,
                  0,
                  w,
                  h
                 ))
      return(false);
   obj.Text(text);
   obj.Font(font);
   obj.FontSize(font_size);
   obj.Color(font_color);
   obj.ColorBackground(bg_color);
   obj.ColorBorder(border_color);
// obj.TextAlign(align);
   obj.Locking(false);
   obj.Pressed(false);
   obj.Hide();
// ObjectSetInteger(0,name,OBJPROP_ZORDER,9999999);
   obj.ZOrder(9999);
   if(!ExtDialog.Add(obj))
      return(false);

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSettingsDialog::CreateCEdit(CEdit &obj, string name, string text, string font, int font_size, color font_color, color bg_color, int w, int h, ENUM_ALIGN_MODE align, bool read_only)
  {
   if(!obj.Create(0,name,0,
                  0,
                  0,
                  w,
                  h
                 ))
      return(false);
   obj.Text(text);
   obj.Font(font);
   obj.FontSize(font_size);
   obj.Color(font_color);
   if(bg_color != 0)
      obj.ColorBackground(bg_color);
   obj.TextAlign(align);
   obj.ReadOnly(read_only);
   obj.Hide();
   obj.ZOrder(9999);
   if(!ExtDialog.Add(obj))
      return(false);

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSettingsDialog::CreateCPanel(CPanel &obj, string name, color borderColor, color bgColor, int w, int h)
  {
   if(!obj.Create(0,name,0,
                  0,
                  0,
                  w,
                  h
                 ))
      return(false);
   
   obj.ColorBackground(bgColor);   
   obj.ColorBorder(borderColor);   
   obj.Hide();
   obj.ZOrder(9999);
   if(!ExtDialog.Add(obj))
      return(false);

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSettingsDialog::CreateCBitmap(CBmpButton &obj,string name,int w,int h, ENUM_ANCHOR_POINT anchor, string onBmpName, string offBmpName)
  {
   if(!obj.Create(0,name,0,
                  0,
                  0,
                  w,
                  h
                 ))
      return(false);
   
   obj.Hide();
   
   ObjectSetInteger(0, name, OBJPROP_ANCHOR, anchor);
   
   obj.BmpNames(offBmpName,onBmpName);
   
   if(!ExtDialog.Add(obj))
      return(false);

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSettingsDialog::CreateCLabel(CLabel &obj, string name, string text, string font, int font_size, color font_color, int w, int h, ENUM_ANCHOR_POINT align, int angle)
  {
// Labelは影響を受けるので補正する
//--- 画面に1.5インチの幅のボタンを作成します
   double screen_dpi = TerminalInfoInteger(TERMINAL_SCREEN_DPI); // ユーザーのモニターのDPIを取得します
   double base_width = 144;                                     // DPI=96の標準モニターの画面のドットの基本の幅

   if(!obj.Create(0,name,0,
                  0,
                  0,
                  w,
                  h
                 ))
      return(false);

   obj.Text(text);
   obj.Font(font);
   obj.FontSize(font_size);
   obj.Color(font_color);
   obj.ColorBorder(clrNONE);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,align);
//ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true);
   ObjectSetDouble(0,name,OBJPROP_ANGLE,angle);
   obj.Hide();
   obj.ZOrder(9999);
   if(!ExtDialog.Add(obj))
      return(false);

   return true;
  }
  
//+------------------------------------------------------------------+ 
//| Create the "SpinEdit" element                                    | 
//+------------------------------------------------------------------+ 
bool CSettingsDialog::CreateCSpinEdit(CSpinEditEx &obj, string name, int w, int h, bool checkable, string suffix) 
  {
  if(!obj.Create(0,name,0,
                  0,
                  0,
                  w,
                  h,
                  checkable
                 ))
      return(false);
   
   obj.Hide();
   if(!ExtDialog.Add(obj))
      return(false);
      
   obj.Suffix(suffix);
   obj.Value(0);
//--- succeed 
   return(true); 
  }   
  
//+------------------------------------------------------------------+ 
//| Create the "Combobox" element                                    | 
//+------------------------------------------------------------------+ 
bool CSettingsDialog::CreateCCombobox(CComboBox &obj, string name, int w, int h) 
  {
  if(!obj.Create(0,name,0,
                  0,
                  0,
                  w,
                  h
                 ))
      return(false);
   
   obj.Hide();
   if(!ExtDialog.Add(obj))
      return(false);
//--- succeed 
   return(true); 
  }

//+------------------------------------------------------------------+ 
//| Create the "Checkbox" element                                    | 
//+------------------------------------------------------------------+ 
bool CSettingsDialog::CreateCCheckBox(CCheckBoxEx &obj,string name,int w,int h, bool noLabelFlag)
  {
  if(!obj.Create(0,name,0,
                  0,
                  0,
                  w,
                  h,
                  noLabelFlag
                 ))
      return(false);
   
   obj.Hide();
   if(!ExtDialog.Add(obj))
      return(false);
//--- succeed 
   return(true); 
  }
  
//+------------------------------------------------------------------+ 
//| Create the "Checkbox" element                                    | 
//+------------------------------------------------------------------+ 
bool CSettingsDialog::CreateCCheckBox(CCheckBoxEx &obj,string name,string text,string font,int font_size,color font_color,int w,int h, bool noLabelFlag)
  {
  if(!obj.Create(0,name,0,
                  0,
                  0,
                  w,
                  h,
                  noLabelFlag
                 ))
      return(false);
   
   obj.Hide();
   if(!ExtDialog.Add(obj))
      return(false);
      
   obj.Text(text);
   obj.Font(common_Font);
   obj.FontSize(font_size);
   obj.Color(font_color);
//--- succeed 
   return(true); 
  }  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSettingsDialog::InitObj(void)
  {
//---
   CAPTION_LEFT = m_label_Caption.Left()-Left();
   CAPTION_TOP = m_label_Caption.Top()-Top();
   
//---
   m_wnd_Client.ColorBackground(mainPanel_BackgroundColor);
   m_wnd_Client.ColorBorder(mainPanel_BackgroundColor);
   m_wnd_Client.ColorBorder(mainPanel_BackgroundColor);
   
   m_label_Caption.ColorBackground(mainPanel_BackgroundColor);
   m_label_Caption.ColorBorder(mainPanel_BorderColor);
   m_panel_Border.ColorBackground(mainPanel_BackgroundColor);
   m_panel_Border.ColorBorder(mainPanel_BorderColor);
   m_panel_Back.ColorBackground(mainPanel_BackgroundColor);
   m_panel_Back.ColorBorder(mainPanel_BorderColor);

   m_button_MinMax.Hide();
   //m_button_Close.Hide();

//--- initialize objects
   if(!CreateCPanel(m_panel_MainPanel, "m_panel_MainPanel", subPanel_BorderColor, subPanel_BackgroundColor, m_wnd_Client.Width(), 165))
      return false;
   if(!CreateCPanel(m_position_menu_main_panel, POSITION_MENU_NAME_PREFIX+"main_panel", position_common_ColorBorder, position_common_ColorBackground, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT*5))
      return false;
   if(!CreateCPanel(m_position_menu_sub_panel, POSITION_MENU_NAME_PREFIX+"sub_panel", position_common_ColorBorder, position_common_ColorBackground, POSITION_MENU_SUB_WIDTH, POSITION_MENU_SUB_HEIGHT_01))
      return false;
   if(!CreateCPanel(m_position_menu_main_exit_panel, POSITION_MENU_NAME_PREFIX+"exit_panel", position_common_ColorBorder, position_common_ColorBackground, POSITION_MENU_MAIN_WIDTH-POSITION_MENU_CLOSE_WIDTH, POSITION_MENU_MAIN_HEIGHT))
      return false;
   if(!CreateCPanel(m_position_menu_main_doten_panel, POSITION_MENU_NAME_PREFIX+"doten_panel", position_common_ColorBorder, position_common_ColorBackground, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT))
      return false;
   if(!CreateCPanel(m_position_menu_main_percent_exit_menu_panel, POSITION_MENU_NAME_PREFIX+"percent_exit_menu_panel", position_common_ColorBorder, position_common_ColorBackground, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT))
      return false;
   if(!CreateCPanel(m_position_menu_main_sltatene_panel, POSITION_MENU_NAME_PREFIX+"sltatene_panel", position_common_ColorBorder, position_common_ColorBackground, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT))
      return false;
   if(!CreateCPanel(m_position_menu_main_trailingstop_menu_panel, POSITION_MENU_NAME_PREFIX+"trailingstop_panel", position_common_ColorBorder, position_common_ColorBackground, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT))
      return false;   
   if(!CreateCPanel(m_position_menu_main_tpsl_menu_panel, POSITION_MENU_NAME_PREFIX+"tpsl_menu_panel", position_common_ColorBorder, position_common_ColorBackground, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT))
      return false; 
   if(!CreateCPanel(m_position_menu_main_ma_tpsl_menu_panel, POSITION_MENU_NAME_PREFIX+"ma_tpsl_menu_panel", position_common_ColorBorder, position_common_ColorBackground, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT))
      return false;
                  
   if(!CreateCLabel(m_label_OrderType, "m_label_OrderType", "Order select", common_Font, common_FontSize, common_FontColor, LABEL_WIDTH_XL, LABEL_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
   if(!CreateCLabel(m_label_LotSize, "m_label_LotSize", "Lot size", common_Font, common_FontSize, common_FontColor, LABEL_WIDTH_XL, LABEL_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
   if(!CreateCLabel(m_label_Takeprofit, "m_label_Takeprofit", "Take profit", common_Font, common_FontSize, common_FontColor, LABEL_WIDTH_XL, LABEL_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
   if(!CreateCLabel(m_label_Stoploss, "m_label_Stoploss", "Stop loss", common_Font, common_FontSize, common_FontColor, LABEL_WIDTH_XL, LABEL_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
   if(!CreateCLabel(m_label_Alert, "m_label_Alert", "Alert", common_Font, common_FontSize, common_FontColor, LABEL_WIDTH_XL, LABEL_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
      
   if(!CreateCLabel(m_position_menu_main_exit, POSITION_MENU_NAME_PREFIX+"menu_main_exit", "", common_Font, position_menu_FontSize, common_FontColor, POSITION_MENU_MAIN_WIDTH-POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
   if(!CreateCLabel(m_position_menu_main_doten, POSITION_MENU_NAME_PREFIX+"menu_main_doten", "　ドテン", common_Font, position_menu_FontSize, common_FontColor, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
   if(!CreateCLabel(m_position_menu_main_percent_exit_menu, POSITION_MENU_NAME_PREFIX+"menu_main_percent_exit_menu", "　分割決済　　　　　＞", common_Font, position_menu_FontSize, common_FontColor, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
   if(!CreateCLabel(m_position_menu_main_sltatene, POSITION_MENU_NAME_PREFIX+"menu_main_sltatene", "　SL建値", common_Font, position_menu_FontSize, common_FontColor, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
   if(!CreateCLabel(m_position_menu_main_trailingstop_menu, POSITION_MENU_NAME_PREFIX+"menu_main_trailingstop_menu", "　自動SL建値　　　   ＞", common_Font, position_menu_FontSize, common_FontColor, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;   
   if(!CreateCLabel(m_position_menu_main_tpsl_menu, POSITION_MENU_NAME_PREFIX+"menu_main_tpsl_menu", "　TP/SL編集　　　　＞", common_Font, position_menu_FontSize, common_FontColor, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
   if(!CreateCLabel(m_position_menu_main_ma_tpsl_menu, POSITION_MENU_NAME_PREFIX+"menu_main_ma_tpsl_menu", "　TP/SL(MA)  　　　＞", common_Font, position_menu_FontSize, common_FontColor, POSITION_MENU_MAIN_WIDTH, POSITION_MENU_MAIN_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;   
   if(!CreateCLabel(m_position_menu_main_percent_label, POSITION_MENU_NAME_PREFIX+"menu_main_percent_label", "分割決済　％", common_Font, position_menu_FontSize, common_FontColor,POSITION_MENU_SUB_WIDTH, POSITION_MENU_MAIN_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
   if(!CreateCLabel(m_position_menu_main_tp_label, POSITION_MENU_NAME_PREFIX+"menu_main_tp_label", "TP", common_Font, position_menu_FontSize, common_FontColor, POSITION_MENU_SUB_LABEL_WIDTH, POSITION_MENU_MAIN_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;
   if(!CreateCLabel(m_position_menu_main_sl_label, POSITION_MENU_NAME_PREFIX+"menu_main_sl_label", "SL", common_Font, position_menu_FontSize, common_FontColor, POSITION_MENU_SUB_LABEL_WIDTH, POSITION_MENU_MAIN_HEIGHT, ANCHOR_LEFT_UPPER))
      return false;   
         
   if(!CreateCEdit(m_position_menu_main_percent_input, POSITION_MENU_NAME_PREFIX+"percent_input", "", common_Font, position_menu_FontSize, common_FontColor, clrWhite, POSITION_MENU_SUB_EDIT_WIDTH, POSITION_MENU_SUB_EDIT_HEIGHT, ALIGN_RIGHT))
      return false;
   if(!CreateCEdit(m_position_menu_sub_trailingstop_targetpips, POSITION_MENU_NAME_PREFIX+"sub_trailingstop_targetpips", "", common_Font, position_menu_FontSize, common_FontColor, clrWhite, POSITION_MENU_SUB_EDIT_WIDTH, POSITION_MENU_SUB_EDIT_HEIGHT, ALIGN_RIGHT))
      return false;   
   if(!CreateCEdit(m_position_menu_main_tpsl_tp_input, POSITION_MENU_NAME_PREFIX+"tpsl_tp_input", "", common_Font, position_menu_FontSize, common_FontColor, clrWhite, POSITION_MENU_SUB_EDIT_WIDTH, POSITION_MENU_SUB_EDIT_HEIGHT, ALIGN_RIGHT))
      return false;
   if(!CreateCEdit(m_position_menu_main_tpsl_sl_input, POSITION_MENU_NAME_PREFIX+"tpsl_sl_input", "", common_Font, position_menu_FontSize, common_FontColor, clrWhite, POSITION_MENU_SUB_EDIT_WIDTH, POSITION_MENU_SUB_EDIT_HEIGHT, ALIGN_RIGHT))
      return false;
   if(!CreateCEdit(m_position_menu_sub_ma_tp_period, POSITION_MENU_NAME_PREFIX+"sub_ma_tp_period", "", common_Font, position_menu_FontSize, common_FontColor, clrWhite, POSITION_EDIT1_WIDTH, POSITION_MENU_SUB_EDIT_HEIGHT, ALIGN_RIGHT))
      return false;
   if(!CreateCEdit(m_position_menu_sub_ma_sl_period, POSITION_MENU_NAME_PREFIX+"sub_ma_sl_period", "", common_Font, position_menu_FontSize, common_FontColor, clrWhite, POSITION_EDIT1_WIDTH, POSITION_MENU_SUB_EDIT_HEIGHT, ALIGN_RIGHT))
      return false;   
      
   if(!CreateCCombobox(m_combox_OrderType, "m_combox_OrderType", EDIT_WIDTH_3XL, EDIT_HEIGHT))
      return false;
   m_combox_OrderType.ItemAdd(BUY_TOUCH, BuyTouch);
   m_combox_OrderType.ItemAdd(SELL_TOUCH, SellTouch);
   m_combox_OrderType.ItemAdd(BUY_BREAKOUT, BuyBreakout);
   m_combox_OrderType.ItemAdd(SELL_BREAKOUT, SellBreakout);
   m_combox_OrderType.ItemAdd(BUY_PULLBACK, BuyPullback);
   m_combox_OrderType.ItemAdd(SELL_PULLBACK, SellPullback);
   m_combox_OrderType.ItemAdd(BUY_ROLE_REVERSAL, BuyRoleReversal);
   m_combox_OrderType.ItemAdd(SELL_ROLE_REVERSAL, SellRoleReversal);
   m_combox_OrderType.SelectByValue(BuyTouch);
   if(!CreateCCombobox(m_position_menu_sub_ma_tp_method, POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_tp_method", EDIT_WIDTH, EDIT_HEIGHT))
      return false;
   m_position_menu_sub_ma_tp_method.ItemAdd("SMA",MODE_SMA);
   m_position_menu_sub_ma_tp_method.ItemAdd("EMA",MODE_EMA);
   m_position_menu_sub_ma_tp_method.ItemAdd("SMMA",MODE_SMMA);
   m_position_menu_sub_ma_tp_method.ItemAdd("LWMA",MODE_LWMA);
   m_position_menu_sub_ma_tp_method.SelectByValue(MODE_SMA);
   if(!CreateCCombobox(m_position_menu_sub_ma_sl_method, POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_sl_method", EDIT_WIDTH, EDIT_HEIGHT))
      return false;
   m_position_menu_sub_ma_sl_method.ItemAdd("SMA",MODE_SMA);
   m_position_menu_sub_ma_sl_method.ItemAdd("EMA",MODE_EMA);
   m_position_menu_sub_ma_sl_method.ItemAdd("SMMA",MODE_SMMA);
   m_position_menu_sub_ma_sl_method.ItemAdd("LWMA",MODE_LWMA);
   m_position_menu_sub_ma_sl_method.SelectByValue(MODE_SMA);
   
   if(!CreateCSpinEdit(m_spin_LotSize, "m_spin_LotSize", EDIT_WIDTH_3XL, EDIT_HEIGHT))
      return false;
   double   min_lot     = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double   max_lot     = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double   lot_step    = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   _lotdigits   = (int) - MathLog10(SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP));    
   m_spin_LotSize.MinValue(min_lot);
   m_spin_LotSize.MaxValue(max_lot);
   m_spin_LotSize.ValueStep(lot_step);
   m_spin_LotSize.ValueDigits(_lotdigits);
   m_spin_LotSize.Value(min_lot);
   
   if(!CreateCSpinEdit(m_spin_Takeprofit, "m_spin_Takeprofit", EDIT_WIDTH_3XL, EDIT_HEIGHT, true, "pips"))
      return false;
   if(!CreateCSpinEdit(m_spin_Stoploss, "m_spin_Stoploss", EDIT_WIDTH_3XL, EDIT_HEIGHT, true, "pips"))
      return false;
   m_spin_Takeprofit.MinValue(0);
   m_spin_Takeprofit.Value(0);
   m_spin_Stoploss.MinValue(0);
   m_spin_Stoploss.Value(0);
   
   if(!CreateCCheckBox(m_chkbox_Alert, "m_chkbox_Alert", EDIT_WIDTH_3XL, EDIT_HEIGHT,true))
      return false;
   if(!CreateCCheckBox(m_position_menu_sub_trailingstop_chk, POSITION_MENU_NAME_PREFIX+"sub_trailingstop_chk","自動SL建値(Pips)",common_Font,position_menu_FontSize,common_FontColor,POSITION_MENU_SUB_WIDTH-10, POSITION_MENU_SUB_LABEL_HEIGHT))
      return false;   
   if(!CreateCCheckBox(m_position_menu_sub_ma_tp_chk, POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_tp_chk","TP",common_Font,position_menu_FontSize,common_FontColor,POSITION_MENU_SUB_LABEL_WIDTH, POSITION_MENU_SUB_LABEL_HEIGHT))
      return false;
   if(!CreateCCheckBox(m_position_menu_sub_ma_sl_chk, POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_sl_chk","SL",common_Font,position_menu_FontSize,common_FontColor,POSITION_MENU_SUB_LABEL_WIDTH, POSITION_MENU_SUB_LABEL_HEIGHT))
      return false;
         
   if(!CreateCButton(m_button_Set, "m_button_Set", "SET", common_Font, common_FontSize_XL, common_FontColor, C'57,141,194', clrBlack, BUTTON_WIDTH_XS, BUTTON_HEIGHT, ALIGN_CENTER))
      return false;                     
   if(!CreateCButton(m_button_CloseBuy, "m_button_CloseBuy", "Close Buy", common_Font, common_FontSize, common_FontColor, C'124,188,54', clrBlack, BUTTON_WIDTH, BUTTON_HEIGHT, ALIGN_CENTER))
      return false;
   if(!CreateCButton(m_button_CloseSell, "m_button_CloseSell", "Close Sell", common_Font, common_FontSize, common_FontColor, C'204,60,68', clrBlack, BUTTON_WIDTH, BUTTON_HEIGHT, ALIGN_CENTER))
      return false;
   if(!CreateCButton(m_button_CloseAll, "m_button_CloseAll", "Close All", common_Font, common_FontSize, clrSilver, C'32,32,32', clrBlack, BUTTON_WIDTH, BUTTON_HEIGHT, ALIGN_CENTER))
      return false;
   if(!CreateCButton(m_button_DeleteAllLines, "m_button_DeleteAllLines", "Delete all line", common_Font, common_FontSize, common_FontColor, C'240,240,240', clrBlack, BUTTON_WIDTH_XL, BUTTON_HEIGHT, ALIGN_CENTER))
      return false;
         
   if(!CreateCButton(m_position_menu_main_close, POSITION_MENU_NAME_PREFIX+"menu_main_close", "×", common_Font, position_menu_FontSize, common_FontColor, position_menu_close_ColorBackground, position_menu_close_ColorBorder, POSITION_MENU_CLOSE_WIDTH, POSITION_MENU_CLOSE_HEIGHT, ALIGN_CENTER))
      return false;
   if(!CreateCButton(m_position_menu_main_percent_exit, POSITION_MENU_NAME_PREFIX+"menu_main_percent_exit", "決済", common_Font, position_menu_FontSize, common_FontColor, position_common_ColorBackground, C'178,195,207', POSITION_MENU_SUB_BUTTON_WIDTH, POSITION_MENU_SUB_BUTTON_HEIGHT, ALIGN_CENTER))
      return false;
   if(!CreateCButton(m_position_menu_sub_trailingstop_set, POSITION_MENU_NAME_PREFIX+"sub_trailingstop_set", "設定", common_Font, position_menu_FontSize, common_FontColor, position_common_ColorBackground, C'178,195,207', POSITION_MENU_SUB_BUTTON_WIDTH, POSITION_MENU_SUB_BUTTON_HEIGHT, ALIGN_CENTER))
      return false;   
   if(!CreateCButton(m_position_menu_main_tpsl_set, POSITION_MENU_NAME_PREFIX+"menu_main_tpsl", "設定", common_Font, position_menu_FontSize, common_FontColor, position_common_ColorBackground, C'178,195,207', POSITION_MENU_SUB_BUTTON_WIDTH, POSITION_MENU_SUB_BUTTON_HEIGHT, ALIGN_CENTER))
      return false;
   if(!CreateCButton(m_position_menu_sub_ma_tpsl_set, POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_set", "設定", common_Font, position_menu_FontSize, common_FontColor, position_common_ColorBackground, C'178,195,207', POSITION_MENU_SUB_BUTTON_WIDTH, POSITION_MENU_SUB_BUTTON_HEIGHT, ALIGN_CENTER))
      return false;   
//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSettingsDialog::MoveObj(void)
  {
   m_panel_MainPanel.Move(m_wnd_Client.Left(),m_wnd_Client.Top());
   m_panel_MainPanel.Show();
   
   int x=m_wnd_Client.Left()+INDENT_LEFT;
   int y=m_wnd_Client.Top()+INDENT_TOP;
   
   m_label_OrderType.Move(x,y);
   m_label_OrderType.Show();   
   m_combox_OrderType.Move(x+LABEL_WIDTH_XL+CONTROLS_GAP_X,y);
   m_combox_OrderType.Show();
   
   y+=LABEL_HEIGHT+CONTROLS_GAP_Y;
   m_label_LotSize.Move(x,y);
   m_label_LotSize.Show();   
   m_spin_LotSize.Move(x+LABEL_WIDTH_XL+CONTROLS_GAP_X,y);
   m_spin_LotSize.Show();
   
   y+=LABEL_HEIGHT+CONTROLS_GAP_Y;
   m_label_Takeprofit.Move(x,y);
   m_label_Takeprofit.Show();
   m_spin_Takeprofit.Move(x+LABEL_WIDTH_XL+CONTROLS_GAP_X,y);
   m_spin_Takeprofit.Show();
   
   y+=LABEL_HEIGHT+CONTROLS_GAP_Y;
   m_label_Stoploss.Move(x,y);
   m_label_Stoploss.Show();
   m_spin_Stoploss.Move(x+LABEL_WIDTH_XL+CONTROLS_GAP_X,y);
   m_spin_Stoploss.Show();
   
   y+=LABEL_HEIGHT+CONTROLS_GAP_Y;
   m_label_Alert.Move(x,y);
   m_label_Alert.Show();
   m_chkbox_Alert.Move(x+LABEL_WIDTH_XL+CONTROLS_GAP_X,y);
   m_chkbox_Alert.Show();
   
   x=m_wnd_Client.Right();
   y+=LABEL_HEIGHT+CONTROLS_GAP_Y;
   m_button_Set.Move(x-BUTTON_WIDTH_XS-INDENT_RIGHT,y);
   m_button_Set.Show();
   
   y+=BUTTON_HEIGHT+CONTROLS_GAP_Y*2;
   m_button_DeleteAllLines.Move(x-BUTTON_WIDTH_XL,y);
   m_button_CloseAll.Move(x-BUTTON_WIDTH_XL-(BUTTON_WIDTH+CONTROLS_GAP_X),y);
   m_button_CloseSell.Move(x-BUTTON_WIDTH_XL-(BUTTON_WIDTH+CONTROLS_GAP_X)*2,y);
   m_button_CloseBuy.Move(x-BUTTON_WIDTH_XL-(BUTTON_WIDTH+CONTROLS_GAP_X)*3,y);
   
   m_button_CloseBuy.Show();
   m_button_CloseSell.Show();
   m_button_CloseAll.Show();
   m_button_DeleteAllLines.Show();
  }
  
bool CSettingsDialog::CreateStoplinesObj(void)
  {
   if(ObjectFind(0,HLINE_ENTRY_NAME)<0)
     {
      if(!ObjectCreate(0,HLINE_ENTRY_NAME,OBJ_HLINE,0,0,0))
         return(false);
      
      ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_COLOR,C'253,170,31');
      ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_BACK,true);   
     }
   
   if(ObjectFind(0,HLINE_TP_NAME)<0)
     {
      if(!ObjectCreate(0,HLINE_TP_NAME,OBJ_HLINE,0,0,0))
         return(false);
         
      ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_COLOR,C'123,183,59');
      ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_SELECTABLE,true);
      ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_SELECTED,true);   
      ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_BACK,true);
      ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);   
     }
     
   if(ObjectFind(0,HLINE_SL_NAME)<0)
     {  
      if(!ObjectCreate(0,HLINE_SL_NAME,OBJ_HLINE,0,0,0))
         return(false);
         
      ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_COLOR,C'205,56,64'); 
      ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_SELECTABLE,true);
      ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_SELECTED,true);
      ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_BACK,true);
      ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);   
     }    
     
   if(ObjectFind(0,LABEL_ENTRY_NAME)<0)
     {      
      if(!ObjectCreate(0,LABEL_ENTRY_NAME,OBJ_EDIT,0,0,0))
         return(false);
         
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_BORDER_COLOR,C'253,170,31');
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_BGCOLOR,C'253,170,31');
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      //ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_XDISTANCE,LABEL_WIDTH_XL);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_YDISTANCE,0);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_XSIZE,LABEL_WIDTH_XL);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_YSIZE,LABEL_HEIGHT);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_ALIGN,ALIGN_CENTER);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_READONLY,true);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_COLOR,clrWhite);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      ObjectSetString(0,LABEL_ENTRY_NAME,OBJPROP_TEXT,"ENTRY");
     }
     
   if(ObjectFind(0,LABEL_TP_NAME)<0)
     {      
      if(!ObjectCreate(0,LABEL_TP_NAME,OBJ_EDIT,0,0,0))
         return(false);
         
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_BORDER_COLOR,C'123,183,59');
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_BGCOLOR,C'123,183,59');
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      //ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER);
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_XDISTANCE,LABEL_WIDTH_XL);
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_YDISTANCE,0);
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_XSIZE,LABEL_WIDTH_XL);
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_YSIZE,LABEL_HEIGHT);
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_ALIGN,ALIGN_CENTER);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_READONLY,true);   
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_COLOR,clrWhite);
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      ObjectSetString(0,LABEL_TP_NAME,OBJPROP_TEXT,"TP");   
     }
     
   if(ObjectFind(0,LABEL_SL_NAME)<0)
     {      
      if(!ObjectCreate(0,LABEL_SL_NAME,OBJ_EDIT,0,0,0))
         return(false);   
      
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_BORDER_COLOR,C'205,56,64');
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_BGCOLOR,C'205,56,64');
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      //ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_ANCHOR,ANCHOR_RIGHT_LOWER);
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_XDISTANCE,LABEL_WIDTH_XL);
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_YDISTANCE,0);
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_XSIZE,LABEL_WIDTH_XL);
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_YSIZE,LABEL_HEIGHT);
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_ALIGN,ALIGN_CENTER);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_READONLY,true);   
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_COLOR,clrWhite);
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      ObjectSetString(0,LABEL_SL_NAME,OBJPROP_TEXT,"SL");   
     }
       
   return(true);   
  }

bool CSettingsDialog::CreateCandletimeObj()
  {
   if(ObjectFind(0,LABEL_CANDLETIME_NAME)<0)
     {
      if(!ObjectCreate(0,LABEL_CANDLETIME_NAME,OBJ_EDIT,0,0,0))
         return(false);
     }
   ObjectSetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_BORDER_COLOR,clrBlack);
   ObjectSetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_BGCOLOR,clrBlack);
   ObjectSetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_XDISTANCE,EDIT_WIDTH);
   ObjectSetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_YDISTANCE,25);
   ObjectSetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_XSIZE,EDIT_WIDTH);
   ObjectSetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_YSIZE,EDIT_HEIGHT);
   ObjectSetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_ALIGN,ALIGN_RIGHT);
   ObjectSetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_READONLY,true);
   ObjectSetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_COLOR,clrWhite);
   ObjectSetString(0,LABEL_CANDLETIME_NAME,OBJPROP_TEXT,"00:00:00");
     
   return(true);
  }
  
bool CSettingsDialog::CreateStopLevelsInfoObj(void)
  {
   if(ObjectFind(0,LABEL_MA_TPSL_INFO_NAME)<0)
     {
      if(!ObjectCreate(0,LABEL_MA_TPSL_INFO_NAME,OBJ_LABEL,0,0,0))
         return(false);
     }
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_XDISTANCE,8);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_YDISTANCE,-100);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_ALIGN,ALIGN_RIGHT);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_FONTSIZE,InpMATPSLInfo_FontSize);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_COLOR,InpMATPSLInfo_FontColor);
   ObjectSetString(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TEXT," ");
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
     
   if(ObjectFind(0,LABEL_TRAILINGSTOP_INFO_NAME)<0)
     {
      if(!ObjectCreate(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJ_LABEL,0,0,0))
         return(false);
     }  
   
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_XDISTANCE,8);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_YDISTANCE,-100);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_ALIGN,ALIGN_RIGHT);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_FONTSIZE,InpTrailingStopInfo_FontSize);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_COLOR,InpTrailingStopInfo_FontColor);
   ObjectSetString(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TEXT," ");
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
     
   return(true);
  }  
  
bool CSettingsDialog::HideAll(string prefix)
  {
//---
   int total=ExtDialog.ControlsTotal();
   // CWndClient*myclient;
   for(int i=0;i<total;i++)
   {
      CWnd*obj=ExtDialog.Control(i);
      string name=obj.Name();
      // PrintFormat("%d is %s",i,name);
      if(StringFind(name,"Client")>0)
      {
         CWndClient *client=(CWndClient*)obj;
         int client_total=client.ControlsTotal();
         for(int j=0;j<client_total;j++)
         {
            CWnd*client_obj=client.Control(j);
            string client_name=client_obj.Name();
            if(StringFind(client_name,prefix)==0)
            {
               client_obj.Hide();
               client_obj.Move(-2000, -2000);
            }
         }
      }
   }
//--- succeed
   return(true);
  }
  
//+------------------------------------------------------------------+
//| Handler of control dragging process                              |
//+------------------------------------------------------------------+
/*bool CSettingsDialog::OnDragProcess(const int x,const int y)
  {
   int dx=x-m_mouse_x;
   int dy=y-m_mouse_y;
//--- check shift
   if(Right()+dx>m_limit_right)
      dx=m_limit_right-Right();
   if(Left()+dx<m_limit_left)
      dx=m_limit_left-Left();
   if(Bottom()+dy>m_limit_bottom)
      dy=m_limit_bottom-Bottom();
   if(Top()+dy<m_limit_top)
      dy=m_limit_top-Top();
//--- shift
   Shift(dx,dy);
//--- save
   m_mouse_x=x;
   m_mouse_y=y;
//--- generate event
   EventChartCustom(CONTROLS_SELF_MESSAGE,ON_DRAG_PROCESS,m_id,0.0,m_name);
//--- handled
   return(true);
  }*/
bool CSettingsDialog::OnDialogDragProcess(void)
  {
   CAppDialog::OnDialogDragProcess();
   
   m_label_Caption.Move(Left()+CAPTION_LEFT,Top()+CAPTION_TOP);

//--- succeed   
   return(true);
  }
  
bool CSettingsDialog::OnDialogDragEnd(void)
  {
   CAppDialog::OnDialogDragEnd();
   
   m_label_Caption.Move(Left()+CAPTION_LEFT,Top()+CAPTION_TOP);
   
   if(GlobalVariableSet(GV_SAL_DIALOG_AXISX,Left())==0 ||
      GlobalVariableSet(GV_SAL_DIALOG_AXISY,Top())==0)
     {
      Print("ERROR: GlobalVariableSet failed! DIALOG_AXES");
     }   

//--- succeed
   return(true);
  }

//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+  
void CSettingsDialog::OnClickButton_Set(void)
  {
   string lineObjName=GetSelectedSRLineName();
   string odrTextObjName=LABEL_ODR_TEXT_NAME_PREFIX+lineObjName;
   string odrStateObjName=LABEL_ODR_STATE_NAME_PREFIX+lineObjName;
   
   ulong execOdrNr=StringToInteger(ObjectGetString(0,lineObjName,OBJPROP_TEXT));
   
   Print("OnClickButton_Set: ",lineObjName);
   
   if(lineObjName!="")
     {   
      if(execOdrNr>0)
        {
         double sl=0, tp=0;
         if(m_spin_Takeprofit.Checked())
            tp=ObjectGetDouble(0,HLINE_TP_NAME,OBJPROP_PRICE);
         if(m_spin_Stoploss.Checked())
            sl=ObjectGetDouble(0,HLINE_SL_NAME,OBJPROP_PRICE);   
         
         if(m_positionInfo.SelectByTicket(execOdrNr))
           {
            double entryPrice=m_positionInfo.PriceOpen();
            
            sl= sl==entryPrice ? 0 : sl;
            tp= tp==entryPrice ? 0 : tp;
            
            if(m_trade.PositionModify(execOdrNr,sl,tp))
              {
               string text=GetCurrentOdrText();
               ObjectSetString(0,odrTextObjName,OBJPROP_TEXT,text);
              }
           }
         else
           {
            Print("WARN: Invalid position #",execOdrNr," selected!");
           }
        }
      else
        {
         string text=GetCurrentOdrText();
         ObjectSetString(0,odrTextObjName,OBJPROP_TEXT,text);
         
         if(OBJ_TREND==ObjectGetInteger(0,lineObjName,OBJPROP_TYPE))
           {
            ObjectSetInteger(0,lineObjName,OBJPROP_COLOR,InpTrendlineColor);
            ObjectSetInteger(0,odrTextObjName,OBJPROP_COLOR,InpTrendlineColor);
            ObjectSetInteger(0,odrStateObjName,OBJPROP_COLOR,InpTrendlineColor);
           }
         else if(OBJ_HLINE==ObjectGetInteger(0,lineObjName,OBJPROP_TYPE))
           {
            ObjectSetInteger(0,lineObjName,OBJPROP_COLOR,InpHorizonlineColor);
            ObjectSetInteger(0,odrTextObjName,OBJPROP_COLOR,InpHorizonlineColor);
            ObjectSetInteger(0,odrStateObjName,OBJPROP_COLOR,InpHorizonlineColor);
           }
            
         AddOrModifyStrategy(lineObjName);     
        }
         
      ObjectSetInteger(0,odrStateObjName,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
     }
     
   OnDeselectSRLine(lineObjName);
  }  
  
void CSettingsDialog::OnClickButton_CloseBuy(void)
  {
   Print("OnClickButton_CloseBuy");
   
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      if(m_positionInfo.SelectByIndex(i))
        {
         if(m_positionInfo.Symbol()==Symbol() && m_positionInfo.PositionType()==POSITION_TYPE_BUY)
           {
            if(!m_trade.PositionClose(m_positionInfo.Ticket()))
              {
               PrintFormat("PositionClose error %d",GetLastError()); // リクエストの送信に失敗した場合、エラーコードを出力する
              }
           }
        }
     }
  }  

void CSettingsDialog::OnClickButton_CloseSell(void)
  {
   Print("OnClickButton_CloseSell");
   
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      if(m_positionInfo.SelectByIndex(i))
        {
         if(m_positionInfo.Symbol()==Symbol() && m_positionInfo.PositionType()==POSITION_TYPE_SELL)
           {
            if(!m_trade.PositionClose(m_positionInfo.Ticket()))
              {
               PrintFormat("PositionClose error %d",GetLastError()); // リクエストの送信に失敗した場合、エラーコードを出力する
              }
           }
        }
     }
  }      

void CSettingsDialog::OnClickButton_CloseAll(void)
  {
   Print("OnClickButton_CloseAll");
   
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      if(m_positionInfo.SelectByIndex(i))
        {
         if(m_positionInfo.Symbol()==Symbol())
           {
            if(!m_trade.PositionClose(m_positionInfo.Ticket()))
              {
               PrintFormat("PositionClose error %d",GetLastError()); // リクエストの送信に失敗した場合、エラーコードを出力する
              }
           }
        }
     }
  }      
  
void CSettingsDialog::OnClickButton_DeleteAllLines(void)
  {
   Print("OnClickButton_DeleteAllLines");
   
   for(int i=ObjectsTotal(0)-1;i>=0;i--)
     {
      string objName=ObjectName(0,i);
      if(StringFind(objName,"Trendline")!=-1 ||
         StringFind(objName,"Horizontal")!=-1 ||
         StringFind(objName,LABEL_ODR_TEXT_NAME_PREFIX)!=-1) 
        {
         ObjectDelete(0,objName);
        }   
     }
     
    OnDeselectSRLine(GetSelectedSRLineName()); 
    
    RemoveAllStrategy();
  } 

void CSettingsDialog::OnChangeCombox_OrderType(void)
  {
   OnChangeSpinEdit_Takeprofit();
   OnChangeSpinEdit_Stoploss();
  }
  
void CSettingsDialog::OnChangeSpinEdit_Takeprofit()
  {
   if(!CreateStoplinesObj())
      return;
     
   if(m_spin_Takeprofit.Checked())
     {
      double stopPriceLevel=0;      
      double entryPrice=0, stopPrice=0, minStopPrice=0;
      double tpPips=0, minTpPips=0;
      
      string lineObjName=GetSelectedSRLineName();
        
      //---
      ulong execOdrNr=StringToInteger(ObjectGetString(0,lineObjName,OBJPROP_TEXT));
      if(execOdrNr>0)
        {
         if(m_positionInfo.SelectByTicket(execOdrNr))
           {
            entryPrice=m_positionInfo.PriceOpen();
           }
         else
           {
            Alert("WARN: ModifyTakeprofit: position #",execOdrNr," already closed!");
            return;
           }
         
         stopPriceLevel=(MathMax(m_symbolInfo.StopsLevel(),m_symbolInfo.FreezeLevel())+1)*m_symbolInfo.Point();
           
         if(m_positionInfo.PositionType()==POSITION_TYPE_BUY)
           {
            minStopPrice=SymbolInfoDouble(NULL,SYMBOL_BID)+stopPriceLevel;
            minTpPips=(minStopPrice-entryPrice)/_Pips;  
           }
         else if(m_positionInfo.PositionType()==POSITION_TYPE_SELL)
           {
            minStopPrice=SymbolInfoDouble(NULL,SYMBOL_ASK)-stopPriceLevel;
            minTpPips=(entryPrice-minStopPrice)/_Pips;
           }
         m_spin_Takeprofit.MinValue(minTpPips);
         
         tpPips=m_spin_Takeprofit.Value();
         if(m_positionInfo.PositionType()==POSITION_TYPE_BUY)
           {
            stopPrice=entryPrice+tpPips*_Pips;
           }
         else if(m_positionInfo.PositionType()==POSITION_TYPE_SELL)
           {
            stopPrice=entryPrice-tpPips*_Pips;
           }
        }
      else
        {
         stopPriceLevel=m_symbolInfo.StopsLevel()*m_symbolInfo.Point();
         
         string selOdrTypeStr=m_combox_OrderType.Select();
         
         if(StringFind(selOdrTypeStr,"Buy")!=-1)
           {
            entryPrice=GetPriceBySRLine(lineObjName)+m_symbolInfo.Spread()*m_symbolInfo.Point();
            minStopPrice=GetPriceBySRLine(lineObjName)+stopPriceLevel;
            minTpPips=(minStopPrice-entryPrice)/_Pips;
           }
         else if(StringFind(selOdrTypeStr,"Sell")!=-1)
           {
            entryPrice=GetPriceBySRLine(lineObjName);
            minStopPrice=GetPriceBySRLine(lineObjName)+m_symbolInfo.Spread()*m_symbolInfo.Point()-stopPriceLevel;
            minTpPips=(entryPrice-minStopPrice)/_Pips;
           }
         m_spin_Takeprofit.MinValue(minTpPips);
         
         tpPips=m_spin_Takeprofit.Value();  
         if(StringFind(selOdrTypeStr,"Buy")!=-1)
           {            
            stopPrice=entryPrice+tpPips*_Pips;
           }
         else if(StringFind(selOdrTypeStr,"Sell")!=-1)
           {
            stopPrice=entryPrice-tpPips*_Pips;
           }
        }  
      
      datetime time=0;
      int x, y;
      ChartTimePriceToXY(0,0,time,stopPrice,x,y);
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_YDISTANCE,y-LABEL_HEIGHT);
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetString(0,LABEL_TP_NAME,OBJPROP_TEXT,"TP "+DoubleToString(tpPips,1));
      ObjectSetDouble(0,HLINE_TP_NAME,OBJPROP_PRICE,stopPrice);
      ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_SELECTED,true);
      
      ChartTimePriceToXY(0,0,time,entryPrice,x,y);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_YDISTANCE,y-LABEL_HEIGHT);
      //ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      //ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetDouble(0,HLINE_ENTRY_NAME,OBJPROP_PRICE,entryPrice);
      //ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      //ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
     }
   else
     {
      m_spin_Takeprofit.MinValue(0);
      m_spin_Takeprofit.Value(0);
      
      if(!m_spin_Stoploss.Checked())
        {
         ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
         ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
        }
      ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);  
      ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
     }
  }  

void CSettingsDialog::OnChangeSpinEdit_Stoploss()
  {
   if(!CreateStoplinesObj())
      return;
      
   if(m_spin_Stoploss.Checked())
     {
      double stopPriceLevel=0;      
      double entryPrice=0, stopPrice=0, minStopPrice=0;
      double slPips=0, minSlPips=0;
      
      string lineObjName=GetSelectedSRLineName();
        
      //--- If already executed, get price info from position
      ulong execOdrNr=StringToInteger(ObjectGetString(0,lineObjName,OBJPROP_TEXT));
      if(execOdrNr>0)
        {   
         if(m_positionInfo.SelectByTicket(execOdrNr))
           {
            entryPrice=m_positionInfo.PriceOpen();
           }
         else
           {
            Alert("WARN: ModifyStoploss: position #",execOdrNr," already closed!");
            return;
           }
         
         stopPriceLevel=(MathMax(m_symbolInfo.StopsLevel(),m_symbolInfo.FreezeLevel())+1)*m_symbolInfo.Point();
           
         if(m_positionInfo.PositionType()==POSITION_TYPE_BUY)
           {
            minStopPrice=SymbolInfoDouble(NULL,SYMBOL_BID)-stopPriceLevel;
            minSlPips=(entryPrice-minStopPrice)/_Pips;  
           }
         else if(m_positionInfo.PositionType()==POSITION_TYPE_SELL)
           {
            minStopPrice=SymbolInfoDouble(NULL,SYMBOL_ASK)+stopPriceLevel;
            minSlPips=(minStopPrice-entryPrice)/_Pips;
           }
         m_spin_Stoploss.MinValue(minSlPips);
         
         slPips=m_spin_Stoploss.Value();
         if(m_positionInfo.PositionType()==POSITION_TYPE_BUY)
           {
            stopPrice=entryPrice-slPips*_Pips;
           }
         else if(m_positionInfo.PositionType()==POSITION_TYPE_SELL)
           {
            stopPrice=entryPrice+slPips*_Pips;
           } 
        }
      else
        {         
         stopPriceLevel=m_symbolInfo.StopsLevel()*m_symbolInfo.Point();
         
         string selOdrTypeStr=m_combox_OrderType.Select();
         
         if(StringFind(selOdrTypeStr,"Buy")!=-1)
           {
            entryPrice=GetPriceBySRLine(lineObjName)+m_symbolInfo.Spread()*m_symbolInfo.Point();
            minStopPrice=GetPriceBySRLine(lineObjName)-stopPriceLevel;
            minSlPips=(entryPrice-minStopPrice)/_Pips;
           }
         else if(StringFind(selOdrTypeStr,"Sell")!=-1)
           {
            entryPrice=GetPriceBySRLine(lineObjName);
            minStopPrice=GetPriceBySRLine(lineObjName)+m_symbolInfo.Spread()*m_symbolInfo.Point()+stopPriceLevel;
            minSlPips=(minStopPrice-entryPrice)/_Pips;
           }
         m_spin_Stoploss.MinValue(minSlPips);
         
         slPips=m_spin_Stoploss.Value();  
         if(StringFind(selOdrTypeStr,"Buy")!=-1)
           {            
            stopPrice=entryPrice-slPips*_Pips;
           }
         else if(StringFind(selOdrTypeStr,"Sell")!=-1)
           {
            stopPrice=entryPrice+slPips*_Pips;
           }
        }  
      
      datetime time=0;
      int x, y;
      ChartTimePriceToXY(0,0,time,stopPrice,x,y);
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_YDISTANCE,y-LABEL_HEIGHT);
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetString(0,LABEL_SL_NAME,OBJPROP_TEXT,"SL "+DoubleToString(slPips,1));
      ObjectSetDouble(0,HLINE_SL_NAME,OBJPROP_PRICE,stopPrice);
      ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_SELECTED,true);
      
      ChartTimePriceToXY(0,0,time,entryPrice,x,y);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_YDISTANCE,y-LABEL_HEIGHT);
      //ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      //ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetDouble(0,HLINE_ENTRY_NAME,OBJPROP_PRICE,entryPrice);
      //ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      //ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);   
     }
   else
     {
      m_spin_Stoploss.MinValue(0);
      m_spin_Stoploss.Value(0);
      
      if(!m_spin_Takeprofit.Checked())
        {
         ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
         ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
        }
      ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);    
      ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
     }
  }
  
void CSettingsDialog::OnPositionMenuClose(void)
{
   Print("OnPositionMenuClose");
   ObjectSetInteger(0, POSITION_NAME_PREFIX + "_button_" + IntegerToString(open_menu_position_ticket), OBJPROP_BGCOLOR, position_line_button_color);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   HideAll(POSITION_MENU_NAME_PREFIX);
}

void CSettingsDialog::OnPositionMenuExit(void)
{
   Print("OnPositionMenuExit");
   if(m_positionInfo.SelectByTicket(open_menu_position_ticket)) // selects the position by index for further access to its properties
      m_trade.PositionClose(m_positionInfo.Ticket());
   //CalcInfo();
   ObjectSetInteger(0, POSITION_NAME_PREFIX + "_button_" + IntegerToString(open_menu_position_ticket), OBJPROP_BGCOLOR, position_line_button_color);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   HideAll(POSITION_MENU_NAME_PREFIX);
}

void CSettingsDialog::OnPositionMenuDoten(void)
{
   Print("OnPositionMenuDoten");
   if(m_positionInfo.SelectByTicket(open_menu_position_ticket)){ // selects the position by index for further access to its properties
      double volume = m_positionInfo.Volume();
      ENUM_POSITION_TYPE type = m_positionInfo.PositionType();
      if(!m_trade.PositionClose(m_positionInfo.Ticket())){
         Print("m_trade.PositionClose Error: ", GetLastError());
         ResetLastError();
      }else{
         if(type == POSITION_TYPE_SELL){
            if(!m_trade.Buy(
               volume,
               _Symbol,
               NormalizeDouble(_LastTick.ask,_Digits),
               0,
               0,
               ""
            )){
               Print("m_trade.Buy Error: ", GetLastError());
               ResetLastError();
            }
         }else{
            if(!m_trade.Sell(
               volume,
               _Symbol,
               NormalizeDouble(_LastTick.bid,_Digits),
               0,
               0,
               ""
            )){
               Print("m_trade.Sell Error: ", GetLastError());
               ResetLastError();
            }
         }
      }
   }
   //CalcInfo();
   ObjectSetInteger(0, POSITION_NAME_PREFIX + "_button_" + IntegerToString(open_menu_position_ticket), OBJPROP_BGCOLOR, position_line_button_color);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   HideAll(POSITION_MENU_NAME_PREFIX);
}

void CSettingsDialog::OnPositionMenuSlTatene(void)
{
   Print("OnPositionMenuSlTatene");
   if(m_positionInfo.SelectByTicket(open_menu_position_ticket)){ // selects the position by index for further access to its properties
      MqlTradeRequest request;
      MqlTradeResult  result;
      MqlTradeCheckResult chkresult;
      ZeroMemory(request);
      ZeroMemory(result);
      ZeroMemory(chkresult);
      //--- 操作パラメータの設定
      request.action  =TRADE_ACTION_SLTP; // 取引操作タイプ
      request.position=m_positionInfo.Ticket();   // ポジションシンボル
      request.symbol=m_positionInfo.Symbol();     // シンボル
      request.sl      =m_positionInfo.PriceOpen();               // ポジションのStop Loss
      request.tp      =m_positionInfo.TakeProfit();               // ポジションのTake Profit
      //--- 変更情報の出力
      PrintFormat("Modify #%I64d %s %s",m_positionInfo.Ticket(),m_positionInfo.Symbol(),EnumToString(m_positionInfo.PositionType()));
      //--- 変更できるかチェック
      if(!OrderCheck(request, chkresult)){
         Print("OrderCheck Error: ", result.retcode, " ", result.comment);
      }
      //--- リクエストの送信
      if(!OrderSend(request,result))
         PrintFormat("OrderSend error %d",GetLastError()); // リクエストの送信に失敗した場合、エラーコードを出力する
      //--- 操作情報 
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   }
   //CalcInfo();
   ObjectSetInteger(0, POSITION_NAME_PREFIX + "_button_" + IntegerToString(open_menu_position_ticket), OBJPROP_BGCOLOR, position_line_button_color);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   HideAll(POSITION_MENU_NAME_PREFIX);
}

void CSettingsDialog::OnPositionMenuPercentMenu(void)
{
   Print("OnPositionMenuPercentMenu");
   // 既に開いていたら閉じる
   if(m_position_menu_main_percent_input.IsVisible()){
      // percent exit設定をどかす
      m_position_menu_main_percent_label.Hide();
      m_position_menu_main_percent_label.Move(-2000, -2000);
      m_position_menu_main_percent_input.Hide();
      m_position_menu_main_percent_input.Move(-2000, -2000);
      m_position_menu_main_percent_exit.Hide();
      m_position_menu_main_percent_exit.Move(-2000, -2000);
      // サブパネルどかす
      m_position_menu_sub_panel.Hide();
      m_position_menu_sub_panel.Move(-2000, -2000);
      // 色を変える
      m_position_menu_main_percent_exit_menu_panel.ColorBackground(position_common_ColorBackground);
      m_position_menu_main_percent_exit_menu_panel.ColorBorder(position_common_ColorBorder);
      return;
   }
   // ts設定をどかす
   m_position_menu_sub_trailingstop_chk.Hide();
   m_position_menu_sub_trailingstop_chk.Move(-2000, -2000);
   m_position_menu_sub_trailingstop_targetpips.Hide();
   m_position_menu_sub_trailingstop_targetpips.Move(-2000, -2000);
   m_position_menu_sub_trailingstop_set.Hide();
   m_position_menu_sub_trailingstop_set.Move(-2000, -2000);
   // tpsl設定をどかす
   m_position_menu_main_tp_label.Hide();
   m_position_menu_main_tp_label.Move(-2000, -2000);
   m_position_menu_main_tpsl_tp_input.Hide();
   m_position_menu_main_tpsl_tp_input.Move(-2000, -2000);
   m_position_menu_main_sl_label.Hide();
   m_position_menu_main_sl_label.Move(-2000, -2000);
   m_position_menu_main_tpsl_sl_input.Hide();
   m_position_menu_main_tpsl_sl_input.Move(-2000, -2000);
   m_position_menu_main_tpsl_set.Hide();
   m_position_menu_main_tpsl_set.Move(-2000, -2000);
   // ma tpsl設定をどかす
   m_position_menu_sub_ma_tp_chk.Hide();
   m_position_menu_sub_ma_tp_chk.Move(-2000, -2000);
   m_position_menu_sub_ma_tp_method.Hide();
   m_position_menu_sub_ma_tp_method.Move(-2000, -2000);
   m_position_menu_sub_ma_tp_period.Hide();
   m_position_menu_sub_ma_tp_period.Move(-2000, -2000);
   m_position_menu_sub_ma_sl_chk.Hide();
   m_position_menu_sub_ma_sl_chk.Move(-2000, -2000);
   m_position_menu_sub_ma_sl_method.Hide();
   m_position_menu_sub_ma_sl_method.Move(-2000, -2000);
   m_position_menu_sub_ma_tp_period.Hide();
   m_position_menu_sub_ma_sl_period.Hide();
   m_position_menu_sub_ma_sl_period.Move(-2000, -2000);
   m_position_menu_sub_ma_tpsl_set.Hide();
   m_position_menu_sub_ma_tpsl_set.Move(-2000, -2000);
   // 色を変える
   m_position_menu_main_percent_exit_menu_panel.ColorBackground(position_menu_active_ColorBackground);
   m_position_menu_main_percent_exit_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_trailingstop_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_trailingstop_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_ma_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_ma_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);
   // ポジションサブパネルを開く
   int x, y;
   x = m_position_menu_main_percent_exit_menu_panel.Right();
   y = m_position_menu_main_percent_exit_menu_panel.Top();
   // パネル
   m_position_menu_sub_panel.Height(POSITION_MENU_SUB_HEIGHT_01);
   m_position_menu_sub_panel.Move(x, y);
   m_position_menu_sub_panel.Show();
   // 部品
   x+=POSITION_MENU_SUB_COL_INDENT;
   m_position_menu_main_percent_label.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_percent_label.Show();
   y+=POSITION_MENU_MAIN_HEIGHT;
   m_position_menu_main_percent_input.Text("100");
   m_position_menu_main_percent_input.Move(x, y);
   m_position_menu_main_percent_input.Show();
   x+=POSITION_MENU_SUB_EDIT_WIDTH + POSITION_MENU_SUB_COL_INDENT;
   m_position_menu_main_percent_exit.Move(x, y);
   m_position_menu_main_percent_exit.Show();
}

void CSettingsDialog::OnPositionMenuTrailingStopMenu(void)
{
   Print("OnPositionMenuTrailingStopMenu");
   // 既に開いていたら閉じる
   if(m_position_menu_sub_trailingstop_targetpips.IsVisible()){
      // ts設定をどかす
      m_position_menu_sub_trailingstop_chk.Hide();
      m_position_menu_sub_trailingstop_chk.Move(-2000, -2000);
      m_position_menu_sub_trailingstop_targetpips.Hide();
      m_position_menu_sub_trailingstop_targetpips.Move(-2000, -2000);
      m_position_menu_sub_trailingstop_set.Hide();
      m_position_menu_sub_trailingstop_set.Move(-2000, -2000);
      // サブパネルどかす
      m_position_menu_sub_panel.Hide();
      m_position_menu_sub_panel.Move(-2000, -2000);
      // 色を変える
      m_position_menu_main_trailingstop_menu_panel.ColorBackground(position_common_ColorBackground);
      m_position_menu_main_trailingstop_menu_panel.ColorBorder(position_common_ColorBorder);
      return;
   }
   // percent exit設定をどかす
   m_position_menu_main_percent_label.Hide();
   m_position_menu_main_percent_label.Move(-2000, -2000);
   m_position_menu_main_percent_input.Hide();
   m_position_menu_main_percent_input.Move(-2000, -2000);
   m_position_menu_main_percent_exit.Hide();
   m_position_menu_main_percent_exit.Move(-2000, -2000);
   // tpsl設定をどかす
   m_position_menu_main_tp_label.Hide();
   m_position_menu_main_tp_label.Move(-2000, -2000);
   m_position_menu_main_tpsl_tp_input.Hide();
   m_position_menu_main_tpsl_tp_input.Move(-2000, -2000);
   m_position_menu_main_sl_label.Hide();
   m_position_menu_main_sl_label.Move(-2000, -2000);
   m_position_menu_main_tpsl_sl_input.Hide();
   m_position_menu_main_tpsl_sl_input.Move(-2000, -2000);
   m_position_menu_main_tpsl_set.Hide();
   m_position_menu_main_tpsl_set.Move(-2000, -2000);
   // ma tpsl設定をどかす
   m_position_menu_sub_ma_tp_chk.Hide();
   m_position_menu_sub_ma_tp_chk.Move(-2000, -2000);
   m_position_menu_sub_ma_tp_method.Hide();
   m_position_menu_sub_ma_tp_method.Move(-2000, -2000);
   m_position_menu_sub_ma_tp_period.Hide();
   m_position_menu_sub_ma_tp_period.Move(-2000, -2000);
   m_position_menu_sub_ma_sl_chk.Hide();
   m_position_menu_sub_ma_sl_chk.Move(-2000, -2000);
   m_position_menu_sub_ma_sl_method.Hide();
   m_position_menu_sub_ma_sl_method.Move(-2000, -2000);
   m_position_menu_sub_ma_tp_period.Hide();
   m_position_menu_sub_ma_sl_period.Hide();
   m_position_menu_sub_ma_sl_period.Move(-2000, -2000);
   m_position_menu_sub_ma_tpsl_set.Hide();
   m_position_menu_sub_ma_tpsl_set.Move(-2000, -2000);
   // 色を変える
   m_position_menu_main_trailingstop_menu_panel.ColorBackground(position_menu_active_ColorBackground);
   m_position_menu_main_trailingstop_menu_panel.ColorBorder(position_common_ColorBorder);   
   m_position_menu_main_percent_exit_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_percent_exit_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_ma_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_ma_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);
   // ポジションサブパネルを開く
   int x, y;
   x = m_position_menu_main_trailingstop_menu_panel.Right();
   y = m_position_menu_main_trailingstop_menu_panel.Top();
   // パネル
   m_position_menu_sub_panel.Height(POSITION_MENU_SUB_HEIGHT_01);
   m_position_menu_sub_panel.Move(x, y);
   m_position_menu_sub_panel.Show();
   // 部品
   x+=POSITION_MENU_SUB_COL_INDENT;
   m_position_menu_sub_trailingstop_chk.Checked(false);
   m_position_menu_sub_trailingstop_chk.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_sub_trailingstop_chk.Show();
   y+=POSITION_MENU_MAIN_HEIGHT;
   m_position_menu_sub_trailingstop_targetpips.Text("5.0");
   m_position_menu_sub_trailingstop_targetpips.Move(x, y);
   m_position_menu_sub_trailingstop_targetpips.Show();
   x+=POSITION_MENU_SUB_EDIT_WIDTH + POSITION_MENU_SUB_COL_INDENT;
   m_position_menu_sub_trailingstop_set.Move(x, y);
   m_position_menu_sub_trailingstop_set.Show();
   
   //---
   for(int i=0;i<ArraySize(_positionTrailingStopSets);i++)
     {
      if(_positionTrailingStopSets[i].ticket==open_menu_position_ticket)
        {
         m_position_menu_sub_trailingstop_chk.Checked(true);
         m_position_menu_sub_trailingstop_targetpips.Text(DoubleToString(_positionTrailingStopSets[i].targetPips,1));
         break;
        }
     }
}

void CSettingsDialog::OnPositionMenuTpSlMenu(void)
{
   Print("OnPositionMenuTpSlMenu");
   // 既に開いていたら閉じる
   if(m_position_menu_main_tpsl_tp_input.IsVisible()){
      // tpsl設定をどかす
      m_position_menu_main_tp_label.Hide();
      m_position_menu_main_tp_label.Move(-2000, -2000);
      m_position_menu_main_tpsl_tp_input.Hide();
      m_position_menu_main_tpsl_tp_input.Move(-2000, -2000);
      m_position_menu_main_sl_label.Hide();
      m_position_menu_main_sl_label.Move(-2000, -2000);
      m_position_menu_main_tpsl_sl_input.Hide();
      m_position_menu_main_tpsl_sl_input.Move(-2000, -2000);
      m_position_menu_main_tpsl_set.Hide();
      m_position_menu_main_tpsl_set.Move(-2000, -2000);
      // サブパネルどかす
      m_position_menu_sub_panel.Hide();
      m_position_menu_sub_panel.Move(-2000, -2000);
      // 色を変える
      m_position_menu_main_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
      m_position_menu_main_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);
      return;
   }
   string tp = "";
   string sl = "";
   if(m_positionInfo.SelectByTicket(open_menu_position_ticket)){
      tp = DoubleToString(m_positionInfo.TakeProfit(), _Digits);
      sl = DoubleToString(m_positionInfo.StopLoss(), _Digits);
   }
   // ts設定をどかす
   m_position_menu_sub_trailingstop_chk.Hide();
   m_position_menu_sub_trailingstop_chk.Move(-2000, -2000);
   m_position_menu_sub_trailingstop_targetpips.Hide();
   m_position_menu_sub_trailingstop_targetpips.Move(-2000, -2000);
   m_position_menu_sub_trailingstop_set.Hide();
   m_position_menu_sub_trailingstop_set.Move(-2000, -2000);
   // tpsl設定をどかす
   m_position_menu_main_percent_label.Hide();
   m_position_menu_main_percent_label.Move(-2000, -2000);
   m_position_menu_main_percent_input.Hide();
   m_position_menu_main_percent_input.Move(-2000, -2000);
   m_position_menu_main_percent_exit.Hide();
   m_position_menu_main_percent_exit.Move(-2000, -2000);
   // ma tpsl設定をどかす
   m_position_menu_sub_ma_tp_chk.Hide();
   m_position_menu_sub_ma_tp_chk.Move(-2000, -2000);
   m_position_menu_sub_ma_tp_method.Hide();
   m_position_menu_sub_ma_tp_method.Move(-2000, -2000);
   m_position_menu_sub_ma_tp_period.Hide();
   m_position_menu_sub_ma_tp_period.Move(-2000, -2000);
   m_position_menu_sub_ma_sl_chk.Hide();
   m_position_menu_sub_ma_sl_chk.Move(-2000, -2000);
   m_position_menu_sub_ma_sl_method.Hide();
   m_position_menu_sub_ma_sl_method.Move(-2000, -2000);
   m_position_menu_sub_ma_tp_period.Hide();
   m_position_menu_sub_ma_sl_period.Hide();
   m_position_menu_sub_ma_sl_period.Move(-2000, -2000);
   m_position_menu_sub_ma_tpsl_set.Hide();
   m_position_menu_sub_ma_tpsl_set.Move(-2000, -2000);
   // 色を変える
   m_position_menu_main_tpsl_menu_panel.ColorBackground(position_menu_active_ColorBackground);
   m_position_menu_main_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);   
   m_position_menu_main_percent_exit_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_percent_exit_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_trailingstop_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_trailingstop_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_ma_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_ma_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);
   // ポジションサブパネルを開く
   int x, y, x_bk;
   x = m_position_menu_main_tpsl_menu_panel.Right();
   y = m_position_menu_main_tpsl_menu_panel.Top();
   // パネル
   m_position_menu_sub_panel.Height(POSITION_MENU_SUB_HEIGHT_02);
   int height = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
   if(y + m_position_menu_sub_panel.Height() > height)
      y = height - m_position_menu_sub_panel.Height();
   m_position_menu_sub_panel.Move(x, y);
   m_position_menu_sub_panel.Show();
   // 部品
   x+=POSITION_MENU_SUB_COL_INDENT;
   m_position_menu_main_tp_label.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_tp_label.Show();
   x_bk = x;
   x+=POSITION_MENU_SUB_LABEL_WIDTH + POSITION_MENU_SUB_COL_INDENT;
   m_position_menu_main_tpsl_tp_input.Text(tp);
   m_position_menu_main_tpsl_tp_input.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_tpsl_tp_input.Show();
   x = x_bk;
   y+=POSITION_MENU_MAIN_HEIGHT;
   m_position_menu_main_sl_label.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_sl_label.Show();
   x_bk = x;
   x+=POSITION_MENU_SUB_LABEL_WIDTH + POSITION_MENU_SUB_COL_INDENT;
   m_position_menu_main_tpsl_sl_input.Text(sl);
   m_position_menu_main_tpsl_sl_input.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_tpsl_sl_input.Show();
   x = x_bk;
   x+=POSITION_MENU_SUB_LABEL_WIDTH + POSITION_MENU_SUB_COL_INDENT;
   y+=POSITION_MENU_MAIN_HEIGHT + POSITION_MENU_SUB_ROW_INDENT;
   m_position_menu_main_tpsl_set.Move(x, y);
   m_position_menu_main_tpsl_set.Show();
}

void CSettingsDialog::OnPositionMenuMATpSlMenu(void)
{
   Print("OnPositionMenuMATpSlMenu");
   // 既に開いていたら閉じる
   if(m_position_menu_sub_ma_tp_period.IsVisible()){
      // tpsl設定をどかす
      m_position_menu_sub_ma_tp_chk.Hide();
      m_position_menu_sub_ma_tp_chk.Move(-2000, -2000);
      m_position_menu_sub_ma_tp_method.Hide();
      m_position_menu_sub_ma_tp_method.Move(-2000, -2000);
      m_position_menu_sub_ma_tp_period.Hide();
      m_position_menu_sub_ma_tp_period.Move(-2000, -2000);
      m_position_menu_sub_ma_sl_chk.Hide();
      m_position_menu_sub_ma_sl_chk.Move(-2000, -2000);
      m_position_menu_sub_ma_sl_method.Hide();
      m_position_menu_sub_ma_sl_method.Move(-2000, -2000);
      m_position_menu_sub_ma_tp_period.Hide();
      m_position_menu_sub_ma_sl_period.Hide();
      m_position_menu_sub_ma_sl_period.Move(-2000, -2000);
      m_position_menu_sub_ma_tpsl_set.Hide();
      m_position_menu_sub_ma_tpsl_set.Move(-2000, -2000);
      // サブパネルどかす
      m_position_menu_sub_panel.Hide();
      m_position_menu_sub_panel.Move(-2000, -2000);
      // 色を変える
      m_position_menu_main_ma_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
      m_position_menu_main_ma_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);
      return;
   }   
   string tpMAPeriod = "10";
   string slMAPeriod = "10";   
   // ts設定をどかす
   m_position_menu_sub_trailingstop_chk.Hide();
   m_position_menu_sub_trailingstop_chk.Move(-2000, -2000);
   m_position_menu_sub_trailingstop_targetpips.Hide();
   m_position_menu_sub_trailingstop_targetpips.Move(-2000, -2000);
   m_position_menu_sub_trailingstop_set.Hide();
   m_position_menu_sub_trailingstop_set.Move(-2000, -2000);
   // tpsl設定をどかす
   m_position_menu_main_percent_label.Hide();
   m_position_menu_main_percent_label.Move(-2000, -2000);
   m_position_menu_main_percent_input.Hide();
   m_position_menu_main_percent_input.Move(-2000, -2000);
   m_position_menu_main_percent_exit.Hide();
   m_position_menu_main_percent_exit.Move(-2000, -2000);
   // ma tpsl設定をどかす
   m_position_menu_main_tp_label.Hide();
   m_position_menu_main_tp_label.Move(-2000, -2000);
   m_position_menu_main_tpsl_tp_input.Hide();
   m_position_menu_main_tpsl_tp_input.Move(-2000, -2000);
   m_position_menu_main_sl_label.Hide();
   m_position_menu_main_sl_label.Move(-2000, -2000);
   m_position_menu_main_tpsl_sl_input.Hide();
   m_position_menu_main_tpsl_sl_input.Move(-2000, -2000);
   m_position_menu_main_tpsl_set.Hide();
   m_position_menu_main_tpsl_set.Move(-2000, -2000);
   // 色を変える
   m_position_menu_main_ma_tpsl_menu_panel.ColorBackground(position_menu_active_ColorBackground);
   m_position_menu_main_ma_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);   
   m_position_menu_main_percent_exit_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_percent_exit_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_trailingstop_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_trailingstop_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);   
   // ポジションサブパネルを開く
   int x, y, x_bk;
   x = m_position_menu_main_ma_tpsl_menu_panel.Right();
   y = m_position_menu_main_ma_tpsl_menu_panel.Top();
   // パネル
   m_position_menu_sub_panel.Height(POSITION_MENU_SUB_HEIGHT_02);
   int height = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
   if(y + m_position_menu_sub_panel.Height() > height)
      y = height - m_position_menu_sub_panel.Height();
   m_position_menu_sub_panel.Move(x, y);
   m_position_menu_sub_panel.Show();
   // 部品
   x+=POSITION_MENU_SUB_COL_INDENT;
   m_position_menu_sub_ma_tp_chk.Checked(false);
   m_position_menu_sub_ma_tp_chk.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_sub_ma_tp_chk.Show();   
   x_bk = x;
   x+=POSITION_MENU_SUB_LABEL_WIDTH + POSITION_MENU_SUB_COL_INDENT - 10;
   m_position_menu_sub_ma_tp_method.SelectByValue(MODE_SMA);
   m_position_menu_sub_ma_tp_method.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_sub_ma_tp_method.Show();
   
   x+=EDIT_WIDTH + POSITION_MENU_SUB_COL_INDENT;
   m_position_menu_sub_ma_tp_period.Text(tpMAPeriod);
   m_position_menu_sub_ma_tp_period.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_sub_ma_tp_period.Show();
   x = x_bk;
   y+=POSITION_MENU_MAIN_HEIGHT;
   m_position_menu_sub_ma_sl_chk.Checked(false);
   m_position_menu_sub_ma_sl_chk.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_sub_ma_sl_chk.Show();   
   x_bk = x;
   x+=POSITION_MENU_SUB_LABEL_WIDTH + POSITION_MENU_SUB_COL_INDENT - 10;
   m_position_menu_sub_ma_sl_method.SelectByValue(MODE_SMA);
   m_position_menu_sub_ma_sl_method.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_sub_ma_sl_method.Show();
   
   x+=EDIT_WIDTH + POSITION_MENU_SUB_COL_INDENT;
   m_position_menu_sub_ma_sl_period.Text(slMAPeriod);
   m_position_menu_sub_ma_sl_period.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_sub_ma_sl_period.Show();
   x = x_bk;
   x+=POSITION_MENU_SUB_LABEL_WIDTH + POSITION_MENU_SUB_COL_INDENT;
   y+=POSITION_MENU_MAIN_HEIGHT + POSITION_MENU_SUB_ROW_INDENT;
   m_position_menu_sub_ma_tpsl_set.Move(x, y);
   m_position_menu_sub_ma_tpsl_set.Show();
   
   //---
   for(int i=0;i<ArraySize(_positionMAStopSets);i++)
     {
      if(_positionMAStopSets[i].ticket==open_menu_position_ticket)
        {
         if(_positionMAStopSets[i].maTpFlg)
           {
            m_position_menu_sub_ma_tp_chk.Checked(true);              
           }
         if(_positionMAStopSets[i].maSlFlg)
           {
            m_position_menu_sub_ma_sl_chk.Checked(true);            
           }
         m_position_menu_sub_ma_tp_method.SelectByValue(_positionMAStopSets[i].maTpMethod);
         m_position_menu_sub_ma_tp_period.Text(IntegerToString(_positionMAStopSets[i].maTpPeriod));  
         m_position_menu_sub_ma_sl_method.SelectByValue(_positionMAStopSets[i].maSlMethod);
         m_position_menu_sub_ma_sl_period.Text(IntegerToString(_positionMAStopSets[i].maSlPeriod));            
         break;
        }
     }
}

void CSettingsDialog::OnPositionMenuExitExec(void)
{
   Print("OnPositionMenuExitExec");
   if(m_positionInfo.SelectByTicket(open_menu_position_ticket)){ // selects the position by index for further access to its properties
      double volume = m_positionInfo.Volume();
      double closeVolume = calcCloseLotToPercent(volume, (int)StringToInteger(m_position_menu_main_percent_input.Text()));
      if(volume <= closeVolume){
         m_trade.PositionClose(m_positionInfo.Ticket()); // close a position by the specified symbol
      }else{
         m_trade.PositionClosePartial(m_positionInfo.Ticket(), closeVolume); // close a position by the specified symbol
      }
   }
   //CalcInfo();
   ObjectSetInteger(0, POSITION_NAME_PREFIX + "_button_" + IntegerToString(open_menu_position_ticket), OBJPROP_BGCOLOR, position_line_button_color);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   HideAll(POSITION_MENU_NAME_PREFIX);
}

void CSettingsDialog::OnPositionMenuTrailingStopSet(void)
  {
   Print("OnPositionMenuTrailingStopSet: ", IntegerToString(open_menu_position_ticket));
   if(m_positionInfo.SelectByTicket(open_menu_position_ticket))   // selects the position by index for further access to its properties
     { 
      int positionTickets_TsTotal=ArraySize(_positionTrailingStopSets);
   
      int idx=-1;   
      for(int i=0;i<positionTickets_TsTotal;i++)
        {
         if(_positionTrailingStopSets[i].ticket==open_menu_position_ticket)
           {
            idx=i;
            break;
           }
        }
      
      if(m_position_menu_sub_trailingstop_chk.Checked())
        {  
         if(idx==-1)
           {
            positionTickets_TsTotal++;
            ArrayResize(_positionTrailingStopSets,positionTickets_TsTotal,10);
            _positionTrailingStopSets[positionTickets_TsTotal-1].ticket=open_menu_position_ticket;
            
            idx=positionTickets_TsTotal-1;
           }
           
         _positionTrailingStopSets[idx].targetPips=StringToDouble(m_position_menu_sub_trailingstop_targetpips.Text());
        }
      else
        {
         if(!m_position_menu_sub_trailingstop_chk.Checked())
           {
            if(idx!=-1)
              {
               ArrayRemove(_positionTrailingStopSets,idx,1);
              }
           }
        }
     }
   
   ObjectSetInteger(0, POSITION_NAME_PREFIX + "_button_" + IntegerToString(open_menu_position_ticket), OBJPROP_BGCOLOR, position_line_button_color);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   HideAll(POSITION_MENU_NAME_PREFIX);
  }
  
void CSettingsDialog::OnPositionMenuTpSlExec(void)
{
   Print("OnPositionMenuTpSlExec");
   if(m_positionInfo.SelectByTicket(open_menu_position_ticket)){ // selects the position by index for further access to its properties
      MqlTradeRequest request;
      MqlTradeResult  result;
      MqlTradeCheckResult chkresult;
      ZeroMemory(request);
      ZeroMemory(result);
      ZeroMemory(chkresult);
      //--- 操作パラメータの設定
      request.action  =TRADE_ACTION_SLTP; // 取引操作タイプ
      request.position=m_positionInfo.Ticket();   // ポジションシンボル
      request.symbol=m_positionInfo.Symbol();     // シンボル
      request.sl      =StringToDouble(m_position_menu_main_tpsl_sl_input.Text());               // ポジションのStop Loss
      request.tp      =StringToDouble(m_position_menu_main_tpsl_tp_input.Text());               // ポジションのTake Profit
      //--- 変更情報の出力
      PrintFormat("Modify #%I64d %s %s",m_positionInfo.Ticket(),m_positionInfo.Symbol(),EnumToString(m_positionInfo.PositionType()));
      //--- 変更できるかチェック
      if(!OrderCheck(request, chkresult)){
         Print("OrderCheck Error: ", result.retcode, " ", result.comment);
      }
      //--- リクエストの送信
      if(!OrderSend(request,result))
         PrintFormat("OrderSend error %d",GetLastError()); // リクエストの送信に失敗した場合、エラーコードを出力する
      //--- 操作情報 
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      
      if(result.retcode==TRADE_RETCODE_DONE)
        {
         //---
         for(int i=0;i<ArraySize(_positionMAStopSets);i++)
           {
            if(_positionMAStopSets[i].ticket==open_menu_position_ticket)
              {
               if(request.tp>0)
                  _positionMAStopSets[i].maTpFlg=false;
               if(request.sl>0)   
                  _positionMAStopSets[i].maSlFlg=false;
               break;
              }
           }
        }
   }
   //CalcInfo();
   ObjectSetInteger(0, POSITION_NAME_PREFIX + "_button_" + IntegerToString(open_menu_position_ticket), OBJPROP_BGCOLOR, position_line_button_color);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   HideAll(POSITION_MENU_NAME_PREFIX);
}
/*
void CSettingsDialog::OnPositionMenuMATpSlCheck(string tpSlObjName)
  {
   Print("OnPositionMenuMATpSlCheck");
   if(StringFind(tpSlObjName,POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_tp_chk")==0)
     {
      Print(":tpchk");
     }
   else if(StringFind(tpSlObjName,POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_sl_chk")==0)
     {
      Print(":slchk");
     }
  }  
*/  
void CSettingsDialog::OnPositionMenuMATpSlMethod(string tpSlObjName)
  {
   Print("OnPositionMenuMATpSlMethod");
   if(StringFind(tpSlObjName,POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_tp_method")==0)
     {
      m_position_menu_sub_ma_tp_method.Expand();
     }
   else if(StringFind(tpSlObjName,POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_sl_method")==0)
     {
      m_position_menu_sub_ma_sl_method.Expand();
     }
  }
  
void CSettingsDialog::OnPositionMenuMATpSlSet(void)
  {
   ObjectSetInteger(0, POSITION_NAME_PREFIX + "_button_" + IntegerToString(open_menu_position_ticket), OBJPROP_BGCOLOR, position_line_button_color);
   ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   HideAll(POSITION_MENU_NAME_PREFIX);
   
   CPositionMAStopSet tmp;
   
   tmp.ticket=open_menu_position_ticket;
   tmp.timeframe=_Period;
   tmp.maTpFlg=m_position_menu_sub_ma_tp_chk.Checked();
   tmp.maTpPeriod=(int)StringToInteger(m_position_menu_sub_ma_tp_period.Text());
   tmp.maTpMethod=(ENUM_MA_METHOD)m_position_menu_sub_ma_tp_method.Value();
   
   tmp.maSlFlg=m_position_menu_sub_ma_sl_chk.Checked();
   tmp.maSlPeriod=(int)StringToInteger(m_position_menu_sub_ma_sl_period.Text());
   tmp.maSlMethod=(ENUM_MA_METHOD)m_position_menu_sub_ma_sl_method.Value();
   
   if(m_positionInfo.SelectByTicket(tmp.ticket))
     {
      if(tmp.maTpFlg)
        {
         int handle=FirstOrCreateMAIndicator(tmp.timeframe,tmp.maTpPeriod,tmp.maTpMethod);
         if(handle!=INVALID_HANDLE)
           {
            double ma[1];
                        
            ResetLastError();
            if(CopyBuffer(handle,0,0,1,ma)==1)
              {
               if((m_positionInfo.PositionType()==POSITION_TYPE_BUY && iClose(_Symbol,0,0)>=ma[0]) ||
                  (m_positionInfo.PositionType()==POSITION_TYPE_SELL && iClose(_Symbol,0,0)<=ma[0]))
                 {
                  tmp.maTpFlg=false;
                 }
              }
            else  
              {
               //--- if the copying fails, tell the error code
               PrintFormat("MA TP: Failed to copy data from the iMA indicator, error code %d",GetLastError());
               tmp.maTpFlg=false;
              }
           }
         else  
           {
            Print("MA TP: Invalid indicator handle!");
            tmp.maTpFlg=false;
           }
        }
      
      if(tmp.maSlFlg)
        {
         int handle=FirstOrCreateMAIndicator(tmp.timeframe,tmp.maSlPeriod,tmp.maSlMethod);
         if(handle!=INVALID_HANDLE)
           {
            double ma[1];
                        
            ResetLastError();
            if(CopyBuffer(handle,0,0,1,ma)==1)
              {
               if((m_positionInfo.PositionType()==POSITION_TYPE_BUY && iClose(_Symbol,0,0)<=ma[0]) ||
                  (m_positionInfo.PositionType()==POSITION_TYPE_SELL && iClose(_Symbol,0,0)>=ma[0]))
                 {
                  tmp.maSlFlg=false;
                 }
              }
            else  
              {
               //--- if the copying fails, tell the error code
               PrintFormat("MA SL: Failed to copy data from the iMA indicator, error code %d",GetLastError());
               tmp.maSlFlg=false;
              }
           }
         else  
           {
            Print("MA SL: Invalid indicator handle!");
            tmp.maSlFlg=false;
           }
        }
      
      int positionMAStopSetsTotal=ArraySize(_positionMAStopSets);
   
      int idx=-1;   
      for(int i=0;i<positionMAStopSetsTotal;i++)
        {
         if(_positionMAStopSets[i].ticket==tmp.ticket)
           {
            idx=i;
            break;
           }
        }
        
      if(idx==-1)
        {
         positionMAStopSetsTotal++;
         ArrayResize(_positionMAStopSets,positionMAStopSetsTotal,10);
         
         idx=positionMAStopSetsTotal-1;
        }
        
      _positionMAStopSets[idx]=tmp;  
      
      if(_positionMAStopSets[idx].maTpFlg || _positionMAStopSets[idx].maSlFlg)
        {
         if(m_positionInfo.SelectByTicket(open_menu_position_ticket))
           {
            if(m_positionInfo.TakeProfit()>0 || m_positionInfo.StopLoss()>0)
              {
               m_trade.PositionModify(open_menu_position_ticket,(_positionMAStopSets[idx].maSlFlg?0:m_positionInfo.StopLoss()),(_positionMAStopSets[idx].maTpFlg?0:m_positionInfo.TakeProfit()));
              }
           }        
        }
     }
  }  
    
void CSettingsDialog::OnCreateSRLine(string lineObjName)
  {
   Print("OnCreateSRLine: "+lineObjName);
   
   //--- Create trendline label if not exist
   string odrTextObjName=LABEL_ODR_TEXT_NAME_PREFIX+lineObjName;
   string odrStateObjName=LABEL_ODR_STATE_NAME_PREFIX+lineObjName;
   if(ObjectFind(0,odrTextObjName)<0)
     {
      ObjectCreate(0,odrTextObjName,OBJ_TEXT,0,0,0);
      ObjectSetString(0,odrTextObjName,OBJPROP_TEXT,GetDefaultOdrText());
     }
   if(ObjectFind(0,odrStateObjName)<0)
     {
      ObjectCreate(0,odrStateObjName,OBJ_TEXT,0,0,0);
      ObjectSetString(0,odrStateObjName,OBJPROP_TEXT,"SET前");
     }
        
   if(OBJ_TREND==(ENUM_OBJECT)ObjectGetInteger(0,lineObjName,OBJPROP_TYPE))
     {
      ObjectSetInteger(0,lineObjName,OBJPROP_COLOR,InpTrendlineColor);
      ObjectSetInteger(0,lineObjName,OBJPROP_WIDTH,InpTrendlineWidth);
      ObjectSetInteger(0,odrTextObjName,OBJPROP_COLOR,InpTrendlineColor);
      ObjectSetInteger(0,odrStateObjName,OBJPROP_COLOR,InpTrendlineColor);
     }
   else if(OBJ_HLINE==(ENUM_OBJECT)ObjectGetInteger(0,lineObjName,OBJPROP_TYPE))
     {
      ObjectSetInteger(0,lineObjName,OBJPROP_COLOR,InpHorizonlineColor);  
      ObjectSetInteger(0,lineObjName,OBJPROP_WIDTH,InpHorizonlineWidth);
      ObjectSetInteger(0,odrTextObjName,OBJPROP_COLOR,InpHorizonlineColor);
      ObjectSetInteger(0,odrStateObjName,OBJPROP_COLOR,InpHorizonlineColor);
      
      AdjustOdrTextXYBySRLine(lineObjName);
     }
       
   ExtDialog.OnSelectSRLine(lineObjName);
  }
  
void CSettingsDialog::OnDeleteSRLine(string lineObjName)
  {
   Print("OnDeleteSRLine: "+lineObjName);
   
   ObjectDelete(0,LABEL_ODR_TEXT_NAME_PREFIX+lineObjName);
   ObjectDelete(0,LABEL_ODR_STATE_NAME_PREFIX+lineObjName);
   
   OnDeselectSRLine(lineObjName);
  }  
      
void CSettingsDialog::OnSelectSRLine(string lineObjName)
  {
   Print("OnSelectSRLine: "+lineObjName);
   
   //-- Deselect all trendlines except the selected line
   for(int i=ObjectsTotal(0)-1;i>=0;i--)
     {
      string objName=ObjectName(0,i);
      ENUM_OBJECT objType=(ENUM_OBJECT)ObjectGetInteger(0,objName,OBJPROP_TYPE);
      
      if(OBJ_TREND==objType || OBJ_HLINE==objType)
        {
         if(objName!=lineObjName)
           {
            if((bool)ObjectGetInteger(0,objName,OBJPROP_SELECTED))
              {
               ObjectSetInteger(0,objName,OBJPROP_SELECTED,false);
               ObjectSetInteger(0,objName,OBJPROP_WIDTH,objType==OBJ_TREND ? InpTrendlineWidth : InpHorizonlineWidth);
              }
           }
        }
     }
     
   //---
   ulong execOdrNr=StringToInteger(ObjectGetString(0,lineObjName,OBJPROP_TEXT));
   if(execOdrNr>0)
     {
      if(!m_positionInfo.SelectByTicket(execOdrNr))
        {
         Print("WARN: Position #",execOdrNr," is already closed, unable to select!");
         
         OnDeselectSRLine(lineObjName,false);
         return;
        }
     }
   
   //---
   RemoveStrategy(lineObjName);
   
   //--- Change caption with trendline name
   Caption(CAPTION_NAME+"  "+lineObjName);
   
   ENUM_OBJECT objType=(ENUM_OBJECT)ObjectGetInteger(0,lineObjName,OBJPROP_TYPE);
   ObjectSetInteger(0,lineObjName,OBJPROP_WIDTH,(objType==OBJ_TREND ? InpTrendlineWidth : InpHorizonlineWidth)+1);
   
   string odrStateObjName=LABEL_ODR_STATE_NAME_PREFIX+lineObjName;   
   ObjectSetInteger(0,odrStateObjName,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   
   string odrTextObjName=LABEL_ODR_TEXT_NAME_PREFIX+lineObjName;
   string odrText=ObjectGetString(0,odrTextObjName,OBJPROP_TEXT);
   
   string tmp[];   
   StringSplit(odrText,'/',tmp);
   int size=ArraySize(tmp);
   for(int i=0;i<size;i++)
     {
      string tokenStr=tmp[i];
      
      StringTrimLeft(tokenStr);
      StringTrimRight(tokenStr);     
      
      switch(i)
        {
         case 0:  //OrderType
           {
            int val=StringToEnumTLOrderType(tokenStr);                  
            m_combox_OrderType.SelectByValue(val);
            break;
           }
         case 1:  //LotSize   
            m_spin_LotSize.Value(StringToDouble(StringSubstr(tokenStr,4)));
            break;
         case 2:  //Stoploss
           {
            double slPips=StringToDouble(StringSubstr(tokenStr,3));
            m_spin_Stoploss.Checked(slPips!=0);            
            if(execOdrNr>0)
               m_spin_Stoploss.MinValue(-9999999);
            m_spin_Stoploss.Value(slPips);
            break;   
           }
         case 3:  //Takeprofit 
           {
            double tpPips=StringToDouble(StringSubstr(tokenStr,3));
            m_spin_Takeprofit.Checked(tpPips!=0);
            if(execOdrNr>0)
               m_spin_Takeprofit.MinValue(-9999999);
            m_spin_Takeprofit.Value(tpPips);
            break;
           }
         case 4:  //Alert
            m_chkbox_Alert.Checked(StringSubstr(tokenStr,6)=="ON");
            break;      
         default:
            break;
        }
     }
     
    Show();
    
    if(execOdrNr>0)
     {
      m_spin_LotSize.ReadOnly(true);
      //--- @todo: its not working now, should be improved
      m_combox_OrderType.Disable();      
      m_chkbox_Alert.Disable();
     }
    else
     {
      m_spin_LotSize.ReadOnly(false);
      //--- @todo: its not working now, should be improved
      m_combox_OrderType.Enable();
      m_chkbox_Alert.Enable();
     }
  }      
  
void CSettingsDialog::OnDeselectSRLine(string lineObjName, bool autoUnselect)
  {
   Print("OnDeselectSRLine: "+lineObjName);
   
   if(lineObjName!="" && autoUnselect)
     {
      ENUM_OBJECT objType=(ENUM_OBJECT)ObjectGetInteger(0,lineObjName,OBJPROP_TYPE);
      
      ObjectSetInteger(0,lineObjName,OBJPROP_WIDTH,objType==OBJ_TREND ? InpTrendlineWidth : InpHorizonlineWidth);
      ObjectSetInteger(0,lineObjName,OBJPROP_SELECTED,false);  
     }
   
   ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);      
   ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);  
   ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);   
     
   Caption(CAPTION_NAME);
   
   Hide();
  }  
  
void CSettingsDialog::OnChangeSRLine(string lineObjName)
  {
   if(GetSelectedSRLineName()!=lineObjName)
      return;
      
   OnChangeCombox_OrderType();
   
   AdjustOdrTextXYBySRLine(lineObjName);
  }
  
void CSettingsDialog::OnMoveStopLine(string stoplineObjName)
  {
   double entryPrice=ObjectGetDouble(0,HLINE_ENTRY_NAME,OBJPROP_PRICE);
   double stopPrice=ObjectGetDouble(0,stoplineObjName,OBJPROP_PRICE);
   
   string selOdrTypeStr=m_combox_OrderType.Select();
      
   if(StringFind(selOdrTypeStr,"Buy")!=-1)
     {
      if(stoplineObjName==HLINE_TP_NAME)
        {
         m_spin_Takeprofit.Value((stopPrice-entryPrice)/_Pips, true);
        }
      else if(stoplineObjName==HLINE_SL_NAME)
        {
         m_spin_Stoploss.Value((entryPrice-stopPrice)/_Pips, true);
        }        
     }
   else if(StringFind(selOdrTypeStr,"Sell")!=-1)
     {
      if(stoplineObjName==HLINE_TP_NAME)
        {
         m_spin_Takeprofit.Value((entryPrice-stopPrice)/_Pips, true);
        }
      else if(stoplineObjName==HLINE_SL_NAME)
        {
         m_spin_Stoploss.Value((stopPrice-entryPrice)/_Pips, true);
        }  
     }
  }

void CSettingsDialog::OnMoveEntryLine(void)
  {
   string lineObjName=GetSelectedSRLineName();
   
   ulong execOdrNr=StringToInteger(ObjectGetString(0,lineObjName,OBJPROP_TEXT));
   
   if(execOdrNr<=0)
     {
      double entryPrice=GetPriceBySRLine(lineObjName);
      double tpPrice=0, slPrice=0;
      
      double tpPips=m_spin_Takeprofit.Value();
      double slPips=m_spin_Stoploss.Value();
      
      string selOdrTypeStr=m_combox_OrderType.Select();
         
      if(StringFind(selOdrTypeStr,"Buy")!=-1)
        {
         entryPrice+=m_symbolInfo.Spread()*m_symbolInfo.Point();
         tpPrice=entryPrice+tpPips*_Pips;
         slPrice=entryPrice-slPips*_Pips;
        }
      else if(StringFind(selOdrTypeStr,"Sell")!=-1)
        {
         tpPrice=entryPrice-tpPips*_Pips;
         slPrice=entryPrice+slPips*_Pips;
        }
           
      datetime time=iTime(NULL,0,0);
      int x, y;
      
      if(m_spin_Takeprofit.Checked())
        {
         ChartTimePriceToXY(0,0,time,tpPrice,x,y);
         ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_YDISTANCE,y-LABEL_HEIGHT);
         ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
         ObjectSetString(0,LABEL_TP_NAME,OBJPROP_TEXT,"TP "+DoubleToString(tpPips,1));
         ObjectSetDouble(0,HLINE_TP_NAME,OBJPROP_PRICE,tpPrice);
         ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
         ObjectSetInteger(0,HLINE_TP_NAME,OBJPROP_SELECTED,true);
        }
      
      if(m_spin_Stoploss.Checked())
        {
         ChartTimePriceToXY(0,0,time,slPrice,x,y);
         ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_YDISTANCE,y-LABEL_HEIGHT);
         ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
         ObjectSetString(0,LABEL_SL_NAME,OBJPROP_TEXT,"SL "+DoubleToString(slPips,1));
         ObjectSetDouble(0,HLINE_SL_NAME,OBJPROP_PRICE,slPrice);
         ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
         ObjectSetInteger(0,HLINE_SL_NAME,OBJPROP_SELECTED,true);
        }
        
      ChartTimePriceToXY(0,0,time,entryPrice,x,y);
      ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_YDISTANCE,y-LABEL_HEIGHT);
      //ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      //ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetDouble(0,HLINE_ENTRY_NAME,OBJPROP_PRICE,entryPrice);
      //ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      //ObjectSetInteger(0,HLINE_ENTRY_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
     }
  }
        
string CSettingsDialog::GetSelectedSRLineName(void)
  {
   string lineObjName=StringSubstr(Caption(),StringLen(CAPTION_NAME));   
   StringTrimLeft(lineObjName);
   
   return(lineObjName);
  }

string CSettingsDialog::GetDefaultOdrText(void)
  {
   string odrType=EnumTLOrderTypeToString(InpDefaultOrderType);
   string lotSize=DoubleToString(InpDefaultLotSize,_lotdigits);   
   string stopLoss=DoubleToString(InpDefaultSL_Pips,1)+" pips";
   string takeProfit=DoubleToString(InpDefaultTP_Pips,1)+" pips";
   string alertOnOff=InpDefaultAlertFlag ? "ON" : "OFF";
   
   string text=odrType+" / Lot "+lotSize+" / SL "+stopLoss+" / TP "+takeProfit+" / Alert "+alertOnOff;
   
   return(text);
  } 
      
string CSettingsDialog::GetCurrentOdrText(void)
  {
   string odrType=EnumTLOrderTypeToString((ENUM_TL_ORDER_TYPE)m_combox_OrderType.Value());
   string lotSize=DoubleToString(m_spin_LotSize.Value(),_lotdigits);   
   string stopLoss=(m_spin_Stoploss.Checked() ? DoubleToString(m_spin_Stoploss.Value(),1) : "0.0")+" pips";
   string takeProfit=(m_spin_Takeprofit.Checked() ? DoubleToString(m_spin_Takeprofit.Value(),1) : "0.0")+" pips";
   string alertOnOff=m_chkbox_Alert.Checked() ? "ON" : "OFF";
   
   string text=odrType+" / Lot "+lotSize+" / SL "+stopLoss+" / TP "+takeProfit+" / Alert "+alertOnOff;
   
   return(text);
  } 
  
void CSettingsDialog::AddOrModifyStrategy(string lineObjName)
  {
   int index=-1;
   int trlineStrategiesTotal=ArraySize(_trlineStrategies);
   
   for(int i=0;i<trlineStrategiesTotal;i++)
     {
      if(CharArrayToString(_trlineStrategies[i].m_LineId)==lineObjName)
        {
         index=i;
         break;
        }
     }
     
   if(index==-1)
     {
      trlineStrategiesTotal++;
      ArrayResize(_trlineStrategies,trlineStrategiesTotal,100);
      index=trlineStrategiesTotal-1;
     }
   
   ENUM_TL_ORDER_TYPE odrType=(ENUM_TL_ORDER_TYPE)m_combox_OrderType.Value();
   double lots=m_spin_LotSize.Value();
   double slPips=m_spin_Stoploss.Value();
   double tpPips=m_spin_Takeprofit.Value();
   double alertFlg=m_chkbox_Alert.Checked();
     
   StringToCharArray(lineObjName,_trlineStrategies[index].m_LineId);  
   _trlineStrategies[index].m_OrderType=odrType;
   _trlineStrategies[index].m_Lots=lots;
   _trlineStrategies[index].m_SL_in_Pips=slPips;
   _trlineStrategies[index].m_TP_in_Pips=tpPips;
   _trlineStrategies[index].m_Alert=alertFlg;
   
   _trlineStrategies[index].m_brktFlg=false;
   _trlineStrategies[index].m_executed=false;
   _trlineStrategies[index].m_startTime=iTime(NULL,0,0);
  }

void CSettingsDialog::RemoveStrategy(string lineObjName)
  {
   int trlineStrategiesTotal=ArraySize(_trlineStrategies);
   
   for(int i=0;i<trlineStrategiesTotal;i++)
     {
      if(CharArrayToString(_trlineStrategies[i].m_LineId)==lineObjName)
        {
         ArrayRemove(_trlineStrategies,i,1);
         break;
        }
     }
  }
  
void CSettingsDialog::RemoveAllStrategy(void)
  {
   ArrayResize(_trlineStrategies,0,100);
  }
  
//+------------------------------------------------------------------+
//| Create the "PositionButtons"                                             |
//+------------------------------------------------------------------+
bool CSettingsDialog::CreateAndUpdatePositionObjects(void)
{
   if(ArraySize(position_label_ys)>0) ArrayRemove(position_label_ys, 0, ArraySize(position_label_ys));
   int horizon_set_flg=0;
   if(horizon_set_flg==1){
      // ポジションラベルを削除する
      if(ArraySize(position_tickets)>0){
         ArrayRemove(position_tickets, 0, ArraySize(position_tickets));
         ObjectsDeleteAll(
            0,  // チャート識別子
            POSITION_NAME_PREFIX,  // オブジェクト名のプレフィックス
            -1,  // ウィンドウ番号
            -1   // オブジェクトの型
         );
      }
      if(ArraySize(position_tps)>0){
         ArrayRemove(position_tps, 0, ArraySize(position_tps));
         ObjectsDeleteAll(
            0,  // チャート識別子
            POSITION_TP_NAME_PREFIX,  // オブジェクト名のプレフィックス
            -1,  // ウィンドウ番号
            -1   // オブジェクトの型
         );
      }
      if(ArraySize(position_sls)>0){
         ArrayRemove(position_sls, 0, ArraySize(position_sls));
         ObjectsDeleteAll(
            0,  // チャート識別子
            POSITION_SL_NAME_PREFIX,  // オブジェクト名のプレフィックス
            -1,  // ウィンドウ番号
            -1   // オブジェクトの型
         );
      }
      if(ArraySize(order_tickets)>0){
         ArrayRemove(order_tickets, 0, ArraySize(order_tickets));
         ObjectsDeleteAll(
            0,  // チャート識別子
            POSITION_ORDER_NAME_PREFIX,  // オブジェクト名のプレフィックス
            -1,  // ウィンドウ番号
            -1   // オブジェクトの型
         );
      }
      // ポジションメニューを削除する
      ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      HideAll(POSITION_MENU_NAME_PREFIX);
   }else{
      // 不要なobjectを削除する
      int totalTp = ArraySize(position_tps);
      for(int i = totalTp-1; i >= 0; i--){
         if(!m_positionInfo.SelectByTicket(position_tps[i]) || !(m_positionInfo.TakeProfit() > 0)){
            if(DeletePositionTpObject(position_tps[i])){
               ArrayRemove(position_tps, i, 1);
            }
         }
      }
      int totalSl = ArraySize(position_sls);
      for(int i = totalSl-1; i >= 0; i--){
         if(!m_positionInfo.SelectByTicket(position_sls[i])){
            if(DeletePositionSlObject(position_sls[i]) || !(m_positionInfo.StopLoss() > 0)){
               ArrayRemove(position_sls, i, 1);
            }
         }
      }
      int totalOrder = ArraySize(order_tickets);
      for(int i = totalOrder-1; i >= 0; i--){
         if(!m_orderInfo.Select(order_tickets[i])){
            if(DeleteOrderObject(order_tickets[i])){
               ArrayRemove(order_tickets, i, 1);
            }
         }
      }
      int total = ArraySize(position_tickets);
      for(int i = total-1; i >= 0; i--){
         if(!m_positionInfo.SelectByTicket(position_tickets[i])){
            if(DeletePositionObject(position_tickets[i])){
               ArrayRemove(position_tickets, i, 1);
            }
         }
      }
      // 新しいobjectsを作成する
      totalTp = ArraySize(position_tps);
      totalSl = ArraySize(position_sls);
      totalOrder = ArraySize(order_tickets);
      total = ArraySize(position_tickets);
      for(int i=OrdersTotal()-1;i>=0;i--){
         if(m_orderInfo.Symbol()==Symbol()){
            if(m_orderInfo.SelectByIndex(i)){
               ulong ticket = m_orderInfo.Ticket();
               totalOrder = ArraySize(order_tickets);
               bool findFlg = false;
               for(int j = totalOrder-1; j >= 0; j--){
                  if(ticket == order_tickets[j]){
                     findFlg = true;
                     break;
                  }
               }
               if(!findFlg){
                  if(CreateOrderObject(ticket)){
                     ArrayResize(order_tickets, ArraySize(order_tickets)+1);
                     order_tickets[totalOrder] = ticket;
                     totalOrder++;
                  }
               }else{
                  MoveOrderObject(ticket);
               }
            }
         }
      }
      for(int i=PositionsTotal()-1;i>=0;i--){
         if(m_positionInfo.SelectByIndex(i)){
            if(m_positionInfo.Symbol()==Symbol()){
               ulong ticket = m_positionInfo.Ticket();
               total = ArraySize(position_tickets);
               bool findFlg = false;
               bool findTpFlg = 0;  // 0=不要、1=作成、2=移動
               bool findSlFlg = 0;  // 0=不要、1=作成、2=移動
               for(int j = total-1; j >= 0; j--){
                  if(ticket == position_tickets[j]){
                     findFlg = true;
                     break;
                  }
               }
               if(m_positionInfo.TakeProfit() > 0){
                  findTpFlg = 1;
                  for(int j = totalTp-1; j >= 0; j--){
                     if(ticket == position_tps[j]){
                        findTpFlg = 2;
                        break;
                     }
                  }
               }
               if(m_positionInfo.StopLoss() > 0){
                  findSlFlg = 1;
                  for(int j = totalSl-1; j >= 0; j--){
                     if(ticket == position_sls[j]){
                        findSlFlg = 2;
                        break;
                     }
                  }
               }
               if(!findFlg){
                  if(CreatePositionObject(ticket)){
                     ArrayResize(position_tickets, ArraySize(position_tickets)+1);
                     position_tickets[total] = ticket;
                     total++;
                  }
               }else{
                  MovePositionObject(ticket);
               }
               if(findTpFlg==1){
                  if(CreatePositionTpObject(ticket)){
                     ArrayResize(position_tps, ArraySize(position_tps)+1);
                     position_tps[totalTp] = ticket;
                     totalTp++;
                  }
               }else if(findTpFlg==2){
                  MovePositionTpObject(ticket);
               }
               if(findSlFlg==1){
                  if(CreatePositionSlObject(ticket)){
                     ArrayResize(position_sls, ArraySize(position_sls)+1);
                     position_sls[totalSl] = ticket;
                     totalSl++;
                  }
               }else if(findSlFlg==2){
                  MovePositionSlObject(ticket);
               }
            }
         }
      }
   }
   //--- succeed
   return(true);
}

bool CSettingsDialog::CreatePositionObject(ulong tickt)
{
   string button_name = POSITION_NAME_PREFIX + "_button_" + IntegerToString(tickt);
   string label_name = POSITION_NAME_PREFIX + "_label_" + IntegerToString(tickt);
   double price = m_positionInfo.PriceOpen();
   double volume = m_positionInfo.Volume();
   string side = "Buy";
   if(m_positionInfo.PositionType() == POSITION_TYPE_SELL)
      side = "Sell";
   ENUM_POSITION_TYPE type = m_positionInfo.PositionType();  // POSITION_TYPE_BUY or POSITION_TYPE_SELL
   double profit = m_positionInfo.Profit();
   int x, y;
   datetime time = iTime(_Symbol,0,0);
   ChartTimePriceToXY(0, 0, time, price, x, y);
   if(!ObjectCreate(0,button_name,     OBJ_EDIT,0,0,0) || !ObjectCreate(0,label_name,     OBJ_EDIT,0,0,0))
   {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
      return(false);
   }
   int widthScreen=(int)ChartGetInteger(ChartID(),CHART_WIDTH_IN_PIXELS,0);
   ObjectSetInteger(0,button_name,     OBJPROP_XSIZE,        POSITION_LABEL1_WIDTH);
   ObjectSetInteger(0,button_name,     OBJPROP_YSIZE,        POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,button_name,     OBJPROP_XDISTANCE,    POSITION_LABEL1_WIDTH + widthScreen/2);
   y = getNonDuplicateY(y, POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,button_name,     OBJPROP_YDISTANCE,    y);
   ObjectSetInteger(0,button_name,     OBJPROP_ALIGN,        ALIGN_CENTER);
   ObjectSetInteger(0,button_name,     OBJPROP_ALIGN,        ALIGN_CENTER);
   ObjectSetInteger(0,button_name,     OBJPROP_CORNER,       CORNER_RIGHT_UPPER);
   ObjectSetString(0,button_name,      OBJPROP_TEXT,         "...");
   ObjectSetString(0,button_name,      OBJPROP_FONT,         common_Font);
   ObjectSetInteger(0,button_name,     OBJPROP_FONTSIZE,     common_FontSize);
   ObjectSetInteger(0,button_name,     OBJPROP_COLOR,        position_line_button_text_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BGCOLOR,      position_line_button_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BORDER_COLOR, position_line_button_border_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BACK,         false);
   ObjectSetInteger(0,button_name,     OBJPROP_SELECTABLE,   false);
   ObjectSetInteger(0,button_name,     OBJPROP_SELECTED,     false);
   ObjectSetInteger(0,button_name,     OBJPROP_READONLY,     true);
   ObjectSetInteger(0,button_name,     OBJPROP_HIDDEN,       true);
   ObjectSetInteger(0,button_name,     OBJPROP_ZORDER,       -1);
   ObjectSetInteger(0, button_name,    OBJPROP_TIMEFRAMES,   OBJ_ALL_PERIODS);
   ObjectSetInteger(0,label_name,     OBJPROP_XSIZE,        POSITION_LABEL2_WIDTH);
   ObjectSetInteger(0,label_name,     OBJPROP_YSIZE,        POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,label_name,     OBJPROP_XDISTANCE,    POSITION_LABEL1_WIDTH + POSITION_LABEL2_WIDTH + 1 + widthScreen/2);
   ObjectSetInteger(0,label_name,     OBJPROP_YDISTANCE,    y);
   ObjectSetInteger(0,label_name,     OBJPROP_ALIGN,        ALIGN_CENTER);
   ObjectSetInteger(0,label_name,     OBJPROP_ALIGN,        ALIGN_CENTER);
   ObjectSetInteger(0,label_name,     OBJPROP_CORNER,       CORNER_RIGHT_UPPER);
   ObjectSetString(0,label_name,      OBJPROP_TEXT,         side + " | " + DoubleToString(volume, 2) + " | " + DoubleToString(profit, 2) + " " + m_accountInfo.Currency());
   ObjectSetString(0,label_name,      OBJPROP_FONT,         common_Font);
   ObjectSetInteger(0,label_name,     OBJPROP_FONTSIZE,     common_FontSize);
   ObjectSetInteger(0,label_name,     OBJPROP_COLOR,        position_line_text_color);
   ObjectSetInteger(0,label_name,     OBJPROP_BGCOLOR,      position_line_color);
   ObjectSetInteger(0,label_name,     OBJPROP_BORDER_COLOR, position_line_color);
   ObjectSetInteger(0,label_name,     OBJPROP_BACK,         false);
   ObjectSetInteger(0,label_name,     OBJPROP_SELECTABLE,   false);
   ObjectSetInteger(0,label_name,     OBJPROP_SELECTED,     false);
   ObjectSetInteger(0,label_name,     OBJPROP_HIDDEN,       true);
   ObjectSetInteger(0,label_name,     OBJPROP_ZORDER,       -1);
   ObjectSetInteger(0, label_name,    OBJPROP_TIMEFRAMES,   OBJ_ALL_PERIODS);

   //--- succeed
   return(true);
}

bool CSettingsDialog::CreatePositionTpObject(ulong tickt)
{
   string button_name = POSITION_TP_NAME_PREFIX + IntegerToString(tickt);
   double price = m_positionInfo.TakeProfit();
   int x, y;
   datetime time = iTime(_Symbol,0,0);
   ChartTimePriceToXY(0, 0, time, price, x, y);
   if(!ObjectCreate(0,button_name,     OBJ_EDIT,0,0,0))
   {
      Print(__FUNCTION__,
            ": failed to create button! Error code = ",GetLastError());
      return(false);
   }
   ObjectSetInteger(0,button_name,     OBJPROP_XSIZE,        POSITION_LABEL1_WIDTH);
   ObjectSetInteger(0,button_name,     OBJPROP_YSIZE,        POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,button_name,     OBJPROP_XDISTANCE,    POSITION_LABEL1_WIDTH);
   y = getNonDuplicateY(y, POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,button_name,     OBJPROP_YDISTANCE,    y);
   ObjectSetInteger(0,button_name,     OBJPROP_ALIGN,        ALIGN_CENTER);
   ObjectSetInteger(0,button_name,     OBJPROP_ALIGN,        ALIGN_CENTER);
   ObjectSetInteger(0,button_name,     OBJPROP_CORNER,       CORNER_RIGHT_UPPER);
   ObjectSetString(0,button_name,      OBJPROP_TEXT,         "×");
   ObjectSetString(0,button_name,      OBJPROP_FONT,         common_Font);
   ObjectSetInteger(0,button_name,     OBJPROP_FONTSIZE,     common_FontSize);
   ObjectSetInteger(0,button_name,     OBJPROP_COLOR,        position_line_tp_button_text_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BGCOLOR,      position_line_tp_button_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BORDER_COLOR, position_line_tp_button_border_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BACK,         false);
   ObjectSetInteger(0,button_name,     OBJPROP_SELECTABLE,   false);
   ObjectSetInteger(0,button_name,     OBJPROP_SELECTED,     false);
   ObjectSetInteger(0,button_name,     OBJPROP_READONLY,     true);
   ObjectSetInteger(0,button_name,     OBJPROP_HIDDEN,       true);
   ObjectSetInteger(0,button_name,     OBJPROP_ZORDER,       -1);
   ObjectSetInteger(0, button_name,    OBJPROP_TIMEFRAMES,   OBJ_ALL_PERIODS);

   //--- succeed
   return(true);
}

bool CSettingsDialog::CreatePositionSlObject(ulong tickt)
{
   string button_name = POSITION_SL_NAME_PREFIX + IntegerToString(tickt);
   double price = m_positionInfo.StopLoss();
   int x, y;
   datetime time = iTime(_Symbol,0,0);
   ChartTimePriceToXY(0, 0, time, price, x, y);
   if(!ObjectCreate(0,button_name,     OBJ_EDIT,0,0,0))
   {
      Print(__FUNCTION__,
            ": failed to create button! Error code = ",GetLastError());
      return(false);
   }
   ObjectSetInteger(0,button_name,     OBJPROP_XSIZE,        POSITION_LABEL1_WIDTH);
   ObjectSetInteger(0,button_name,     OBJPROP_YSIZE,        POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,button_name,     OBJPROP_XDISTANCE,    POSITION_LABEL1_WIDTH);
   y = getNonDuplicateY(y, POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,button_name,     OBJPROP_YDISTANCE,    y);
   ObjectSetInteger(0,button_name,     OBJPROP_ALIGN,        ALIGN_CENTER);
   ObjectSetInteger(0,button_name,     OBJPROP_ALIGN,        ALIGN_CENTER);
   ObjectSetInteger(0,button_name,     OBJPROP_CORNER,       CORNER_RIGHT_UPPER);
   ObjectSetString(0,button_name,      OBJPROP_TEXT,         "×");
   ObjectSetString(0,button_name,      OBJPROP_FONT,         common_Font);
   ObjectSetInteger(0,button_name,     OBJPROP_FONTSIZE,     common_FontSize);
   ObjectSetInteger(0,button_name,     OBJPROP_COLOR,        position_line_sl_button_text_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BGCOLOR,      position_line_sl_button_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BORDER_COLOR, position_line_sl_button_border_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BACK,         false);
   ObjectSetInteger(0,button_name,     OBJPROP_SELECTABLE,   false);
   ObjectSetInteger(0,button_name,     OBJPROP_SELECTED,     false);
   ObjectSetInteger(0,button_name,     OBJPROP_READONLY,     true);
   ObjectSetInteger(0,button_name,     OBJPROP_HIDDEN,       true);
   ObjectSetInteger(0,button_name,     OBJPROP_ZORDER,       -1);
   ObjectSetInteger(0, button_name,    OBJPROP_TIMEFRAMES,   OBJ_ALL_PERIODS);

   //--- succeed
   return(true);
}

bool CSettingsDialog::CreateOrderObject(ulong tickt)
{
   string button_name = POSITION_ORDER_NAME_PREFIX + IntegerToString(tickt);
   double price = m_orderInfo.PriceOpen();
   int x, y;
   datetime time = iTime(_Symbol,0,0);
   ChartTimePriceToXY(0, 0, time, price, x, y);
   if(!ObjectCreate(0,button_name,     OBJ_EDIT,0,0,0))
   {
      Print(__FUNCTION__,
            ": failed to create button! Error code = ",GetLastError());
      return(false);
   }
   ObjectSetInteger(0,button_name,     OBJPROP_XSIZE,        POSITION_LABEL1_WIDTH);
   ObjectSetInteger(0,button_name,     OBJPROP_YSIZE,        POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,button_name,     OBJPROP_XDISTANCE,    POSITION_LABEL1_WIDTH);
   y = getNonDuplicateY(y, POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,button_name,     OBJPROP_YDISTANCE,    y);
   ObjectSetInteger(0,button_name,     OBJPROP_ALIGN,        ALIGN_CENTER);
   ObjectSetInteger(0,button_name,     OBJPROP_CORNER,       CORNER_RIGHT_UPPER);
   ObjectSetString(0,button_name,      OBJPROP_TEXT,         "×");
   ObjectSetString(0,button_name,      OBJPROP_FONT,         common_Font);
   ObjectSetInteger(0,button_name,     OBJPROP_FONTSIZE,     common_FontSize);
   ObjectSetInteger(0,button_name,     OBJPROP_COLOR,        position_line_order_button_text_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BGCOLOR,      position_line_order_button_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BORDER_COLOR, position_line_order_button_border_color);
   ObjectSetInteger(0,button_name,     OBJPROP_BACK,         false);
   ObjectSetInteger(0,button_name,     OBJPROP_SELECTABLE,   false);
   ObjectSetInteger(0,button_name,     OBJPROP_SELECTED,     false);
   ObjectSetInteger(0,button_name,     OBJPROP_READONLY,     true);
   ObjectSetInteger(0,button_name,     OBJPROP_HIDDEN,       true);
   ObjectSetInteger(0,button_name,     OBJPROP_ZORDER,       -1);
   ObjectSetInteger(0, button_name,    OBJPROP_TIMEFRAMES,   OBJ_ALL_PERIODS);

   //--- succeed
   return(true);
}

bool CSettingsDialog::DeletePositionObject(ulong tickt)
{
   string button_name = POSITION_NAME_PREFIX + "_button_" + IntegerToString(tickt);
   string label_name = POSITION_NAME_PREFIX + "_label_" + IntegerToString(tickt);
   if(!ObjectDelete(0,label_name) || !ObjectDelete(0,button_name))
   {
      Print(__FUNCTION__,
            ": failed to delete text label! Error code = ",GetLastError());
      return(false);
   }
   //--- succeed
   return(true);
}

bool CSettingsDialog::DeletePositionTpObject(ulong tickt)
{
   string button_name = POSITION_TP_NAME_PREFIX + IntegerToString(tickt);
   if(!ObjectDelete(0,button_name))
   {
      Print(__FUNCTION__,
            ": failed to delete button! Error code = ",GetLastError());
      return(false);
   }
   //--- succeed
   return(true);
}

bool CSettingsDialog::DeletePositionSlObject(ulong tickt)
{
   string button_name = POSITION_SL_NAME_PREFIX + IntegerToString(tickt);
   if(!ObjectDelete(0,button_name))
   {
      Print(__FUNCTION__,
            ": failed to delete button! Error code = ",GetLastError());
      return(false);
   }
   //--- succeed
   return(true);
}

bool CSettingsDialog::DeleteOrderObject(ulong tickt)
{
   string button_name = POSITION_ORDER_NAME_PREFIX + IntegerToString(tickt);
   if(!ObjectDelete(0,button_name))
   {
      Print(__FUNCTION__,
            ": failed to delete button! Error code = ",GetLastError());
      return(false);
   }
   //--- succeed
   return(true);
}

bool CSettingsDialog::MovePositionObject(ulong tickt)
{
   string button_name = POSITION_NAME_PREFIX + "_button_" + IntegerToString(tickt);
   string label_name = POSITION_NAME_PREFIX + "_label_" + IntegerToString(tickt);
   double price = m_positionInfo.PriceOpen();
   double volume = m_positionInfo.Volume();
   string side = "Buy";
   if(m_positionInfo.PositionType() == POSITION_TYPE_SELL)
      side = "Sell";
   ENUM_POSITION_TYPE type = m_positionInfo.PositionType();  // POSITION_TYPE_BUY or POSITION_TYPE_SELL
   double profit = m_positionInfo.Profit();
   int x, y;
   datetime time = iTime(_Symbol,0,0);
   ChartTimePriceToXY(0, 0, time, price, x, y);
   int widthScreen=(int)ChartGetInteger(ChartID(),CHART_WIDTH_IN_PIXELS,0);
   ObjectSetInteger(0,button_name,     OBJPROP_XDISTANCE,    POSITION_LABEL1_WIDTH + widthScreen/2);
   y = getNonDuplicateY(y, POSITION_LABEL_HEIGHT);   
   ObjectSetInteger(0,button_name,     OBJPROP_YDISTANCE,    y);
   ObjectSetInteger(0,label_name,     OBJPROP_XDISTANCE,    POSITION_LABEL1_WIDTH + POSITION_LABEL2_WIDTH + 1 + widthScreen/2);
   ObjectSetInteger(0,label_name,     OBJPROP_YDISTANCE,    y);
   ObjectSetString(0,label_name,      OBJPROP_TEXT,         side + " | " + DoubleToString(volume, 2) + " | " + DoubleToString(profit, 2) + " " + m_accountInfo.Currency());
   //--- succeed
   return(true);
}

bool CSettingsDialog::MovePositionTpObject(ulong tickt)
{
   string button_name = POSITION_TP_NAME_PREFIX + IntegerToString(tickt);
   double price = m_positionInfo.TakeProfit();
   int x, y;
   datetime time = iTime(_Symbol,0,0);
   ChartTimePriceToXY(0, 0, time, price, x, y);
   ObjectSetInteger(0,button_name,     OBJPROP_XDISTANCE,    POSITION_LABEL1_WIDTH);
   y = getNonDuplicateY(y, POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,button_name,     OBJPROP_YDISTANCE,    y);
   //--- succeed
   return(true);
}

bool CSettingsDialog::MovePositionSlObject(ulong tickt)
{
   string button_name = POSITION_SL_NAME_PREFIX + IntegerToString(tickt);
   double price = m_positionInfo.StopLoss();
   int x, y;
   datetime time = iTime(_Symbol,0,0);
   ChartTimePriceToXY(0, 0, time, price, x, y);
   ObjectSetInteger(0,button_name,     OBJPROP_XDISTANCE,    POSITION_LABEL1_WIDTH);
   y = getNonDuplicateY(y, POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,button_name,     OBJPROP_YDISTANCE,    y);
   //--- succeed
   return(true);
}

bool CSettingsDialog::MoveOrderObject(ulong tickt)
{
   string button_name = POSITION_ORDER_NAME_PREFIX + IntegerToString(tickt);
   double price = m_orderInfo.PriceOpen();
   int x, y;
   datetime time = iTime(_Symbol,0,0);
   ChartTimePriceToXY(0, 0, time, price, x, y);
   ObjectSetInteger(0,button_name,     OBJPROP_XDISTANCE,    POSITION_LABEL1_WIDTH);
   y = getNonDuplicateY(y, POSITION_LABEL_HEIGHT);
   ObjectSetInteger(0,button_name,     OBJPROP_YDISTANCE,    y);
   //--- succeed
   return(true);
}

bool CSettingsDialog::CreatePositionMenu(int x, int y, string sparam){
   // 選択したpositionチケットを設定する
   string tmp_ticket = sparam;
   StringReplace(tmp_ticket, POSITION_NAME_PREFIX + "_button_", "");
   // 既に開いていたら閉じる
   if(
      m_position_menu_main_panel.IsVisible()
      && StringToInteger(tmp_ticket) == open_menu_position_ticket
   ){
      // ボタンの色を戻す
      ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, position_line_button_color);
      ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      HideAll(POSITION_MENU_NAME_PREFIX);
      return true;
   }else if(StringToInteger(tmp_ticket) != open_menu_position_ticket){
      // 違うボタンが押されたので、前のボタンの色を戻す
      ObjectSetInteger(0, POSITION_NAME_PREFIX + "_button_" + IntegerToString(open_menu_position_ticket), OBJPROP_BGCOLOR, position_line_button_color);
   }
   // ボタンの色を押してる風に変える
   ObjectSetInteger(0, sparam, OBJPROP_BGCOLOR, position_line_button_active_color);

   open_menu_position_ticket = (int)StringToInteger(tmp_ticket);
   m_position_menu_main_exit.Text("　決済　" + tmp_ticket);
   // Print("open_menu_position_ticket: ", open_menu_position_ticket);
   // Print("x=", x, " y=", y);

   // 色を変える
   m_position_menu_main_percent_exit_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_percent_exit_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_trailingstop_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_trailingstop_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);
   m_position_menu_main_ma_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
   m_position_menu_main_ma_tpsl_menu_panel.ColorBorder(position_common_ColorBorder);
   // メニューを表示する
   int height = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
   if(y + m_position_menu_main_panel.Height() > height)
      y = height - m_position_menu_main_panel.Height();
   //x = x - POSITION_MENU_MAIN_WIDTH - POSITION_MENU_SUB_WIDTH - POSITION_LABEL1_WIDTH;
   x += POSITION_LABEL1_WIDTH / 3;
   // パネル
   m_position_menu_main_panel.Move(x, y);
   m_position_menu_main_panel.Show();
   // 部品
   m_position_menu_main_close.Move(x + POSITION_MENU_MAIN_WIDTH - POSITION_MENU_CLOSE_WIDTH, y);
   m_position_menu_main_close.Show();
   m_position_menu_main_exit_panel.Move(x, y);
   m_position_menu_main_exit_panel.Show();
   m_position_menu_main_exit.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_exit.Show();
   y+=POSITION_MENU_MAIN_HEIGHT;
   m_position_menu_main_doten_panel.Move(x, y);
   m_position_menu_main_doten_panel.Show();
   m_position_menu_main_doten.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_doten.Show();
   y+=POSITION_MENU_MAIN_HEIGHT;
   m_position_menu_main_percent_exit_menu_panel.Move(x, y);
   m_position_menu_main_percent_exit_menu_panel.Show();
   m_position_menu_main_percent_exit_menu.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_percent_exit_menu.Show();
   y+=POSITION_MENU_MAIN_HEIGHT;
   m_position_menu_main_sltatene_panel.Move(x, y);
   m_position_menu_main_sltatene_panel.Show();
   m_position_menu_main_sltatene.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_sltatene.Show();
   y+=POSITION_MENU_MAIN_HEIGHT;
   m_position_menu_main_trailingstop_menu_panel.Move(x, y);
   m_position_menu_main_trailingstop_menu_panel.Show();
   m_position_menu_main_trailingstop_menu.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_trailingstop_menu.Show();
   y+=POSITION_MENU_MAIN_HEIGHT;
   m_position_menu_main_tpsl_menu_panel.Move(x, y);
   m_position_menu_main_tpsl_menu_panel.Show();
   m_position_menu_main_tpsl_menu.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_tpsl_menu.Show();
   y+=POSITION_MENU_MAIN_HEIGHT;
   m_position_menu_main_ma_tpsl_menu_panel.Move(x, y);
   m_position_menu_main_ma_tpsl_menu_panel.Show();
   m_position_menu_main_ma_tpsl_menu.Move(x, y + POSITION_MENU_MAIN_HEIGHT/4);
   m_position_menu_main_ma_tpsl_menu.Show();
   
   //---
   bool maTpSlSet=false;   
   bool trailingStopSet=false;
   
   for(int i=0;i<ArraySize(_positionMAStopSets);i++)
     {
      if(_positionMAStopSets[i].ticket==open_menu_position_ticket)
        {
         string text="";
         if(_positionMAStopSets[i].maTpFlg)
           {
            text+=tf2str(_positionMAStopSets[i].timeframe)+", TP MA"+IntegerToString(_positionMAStopSets[i].maTpPeriod)+" ON";
           }
         if(_positionMAStopSets[i].maSlFlg)
           {
            if(_positionMAStopSets[i].maTpFlg)
               text+=", ";
            else
               text+=tf2str(_positionMAStopSets[i].timeframe)+", ";
                  
            text+="SL MA"+IntegerToString(_positionMAStopSets[i].maSlPeriod)+" ON";
           }
         if(_positionMAStopSets[i].maTpFlg ||
            _positionMAStopSets[i].maSlFlg)
           {  
            ObjectSetString(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TEXT,text);
            maTpSlSet=true;
           }
         break;
        }
     }
   if(maTpSlSet)
      ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   else
      ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   
   for(int i=0;i<ArraySize(_positionTrailingStopSets);i++)
     {
      if(_positionTrailingStopSets[i].ticket==open_menu_position_ticket)
        {
         ObjectSetString(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TEXT,"自動SL建値 "+DoubleToString(_positionTrailingStopSets[i].targetPips,1)+"Pips ON");
         trailingStopSet=true;
         break;
        }
     } 
   if(trailingStopSet)
      ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   else
      ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);

   //--- succeed
   return(true);
}

bool CSettingsDialog::RemovePositionTp(int x, int y, string sparam){
   // 選択したpositionチケットを設定する
   string tmp_ticket = sparam;
   StringReplace(tmp_ticket, POSITION_TP_NAME_PREFIX, "");
   ulong ticket = StringToInteger(tmp_ticket);
   Print("ticket: ", ticket);

   if(m_positionInfo.SelectByTicket(ticket)){
      MqlTradeRequest request;
      MqlTradeResult  result;
      MqlTradeCheckResult chkresult;
      ZeroMemory(request);
      ZeroMemory(result);
      ZeroMemory(chkresult);
      //--- 操作パラメータの設定
      request.action  =TRADE_ACTION_SLTP; // 取引操作タイプ
      request.position=m_positionInfo.Ticket();   // ポジションシンボル
      request.symbol=m_positionInfo.Symbol();     // シンボル
      request.sl      =m_positionInfo.StopLoss();               // ポジションのStop Loss
      request.tp      =0;               // ポジションのTake Profit
      //--- 変更情報の出力
      PrintFormat("Modify #%I64d %s %s",m_positionInfo.Ticket(),m_positionInfo.Symbol(),EnumToString(m_positionInfo.PositionType()));
      //--- 変更できるかチェック
      if(!OrderCheck(request, chkresult)){
         Print("OrderCheck Error: ", result.retcode, " ", result.comment);
         return (false);
      }
      //--- リクエストの送信
      if(!OrderSend(request,result)){
         PrintFormat("OrderSend error %d",GetLastError()); // リクエストの送信に失敗した場合、エラーコードを出力する
         return (false);
      }
      //--- 操作情報 
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      ObjectDelete(0,sparam);
   }

   //--- succeed
   return(true);
}

bool CSettingsDialog::RemovePositionSl(int x, int y, string sparam){
   // 選択したpositionチケットを設定する
   string tmp_ticket = sparam;
   StringReplace(tmp_ticket, POSITION_SL_NAME_PREFIX, "");
   ulong ticket = StringToInteger(tmp_ticket);
   Print("ticket: ", ticket);

   if(m_positionInfo.SelectByTicket(ticket)){
      MqlTradeRequest request;
      MqlTradeResult  result;
      MqlTradeCheckResult chkresult;
      ZeroMemory(request);
      ZeroMemory(result);
      ZeroMemory(chkresult);
      //--- 操作パラメータの設定
      request.action  =TRADE_ACTION_SLTP; // 取引操作タイプ
      request.position=m_positionInfo.Ticket();   // ポジションシンボル
      request.symbol=m_positionInfo.Symbol();     // シンボル
      request.sl      =0;               // ポジションのStop Loss
      request.tp      =m_positionInfo.TakeProfit();               // ポジションのTake Profit
      //--- 変更情報の出力
      PrintFormat("Modify #%I64d %s %s",m_positionInfo.Ticket(),m_positionInfo.Symbol(),EnumToString(m_positionInfo.PositionType()));
      //--- 変更できるかチェック
      if(!OrderCheck(request, chkresult)){
         Print("OrderCheck Error: ", result.retcode, " ", result.comment);
         return (false);
      }
      //--- リクエストの送信
      if(!OrderSend(request,result)){
         PrintFormat("OrderSend error %d",GetLastError()); // リクエストの送信に失敗した場合、エラーコードを出力する
         return (false);
      }
      //--- 操作情報 
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      ObjectDelete(0,sparam);
   }

   //--- succeed
   return(true);
}

bool CSettingsDialog::RemoveOrder(int x, int y, string sparam){
   // 選択したpositionチケットを設定する
   string tmp_ticket = sparam;
   StringReplace(tmp_ticket, POSITION_ORDER_NAME_PREFIX, "");
   ulong ticket = StringToInteger(tmp_ticket);
   Print("ticket: ", ticket);

   if(m_orderInfo.Select(ticket)){
      MqlTradeRequest request;
      MqlTradeResult  result;
      MqlTradeCheckResult chkresult;
      ZeroMemory(request);
      ZeroMemory(result);
      ZeroMemory(chkresult);
      //--- 操作パラメータの設定
      request.action  =TRADE_ACTION_REMOVE; // 取引操作タイプ
      request.order = m_orderInfo.Ticket();
      if(!OrderSend(request,result)){
         PrintFormat("OrderSend error %d",GetLastError()); // リクエストの送信に失敗した場合、エラーコードを出力する
      }
      ObjectDelete(0,sparam);
   }

   //--- succeed
   return(true);
}

bool CSettingsDialog::ChkOnMouse(int x, int y, string sparam){
   // Print("ChkOnMouse ", x, " ", y, " ", sparam);

   if(m_position_menu_main_panel.IsVisible()){
      // ポジションメニューが出ている
      // ×ボタン
      if(
         m_position_menu_main_close.Left() <= x && 
         m_position_menu_main_close.Left() + m_position_menu_main_close.Width() >= x &&
         m_position_menu_main_close.Top() <= y && 
         m_position_menu_main_close.Top() + m_position_menu_main_close.Height() >= y
      ){
         if(m_position_menu_main_close.ColorBackground() == position_menu_close_ColorBackground){
            m_position_menu_main_close.ColorBackground(position_menu_close_ColorBackground_active);
         }
      }else if(m_position_menu_main_close.ColorBackground() == position_menu_close_ColorBackground_active){
         m_position_menu_main_close.ColorBackground(position_menu_close_ColorBackground);
      }
      // 決済ボタン
      if(
         m_position_menu_main_exit_panel.Left() <= x && 
         m_position_menu_main_exit_panel.Left() + m_position_menu_main_exit_panel.Width() >= x &&
         m_position_menu_main_exit_panel.Top() <= y && 
         m_position_menu_main_exit_panel.Top() + m_position_menu_main_exit_panel.Height() >= y
      ){
         if(m_position_menu_main_exit_panel.ColorBackground() == position_common_ColorBackground){
            m_position_menu_main_exit_panel.ColorBackground(position_menu_active_ColorBackground);
         }
      }else if(m_position_menu_main_exit_panel.ColorBackground() == position_menu_active_ColorBackground){
         m_position_menu_main_exit_panel.ColorBackground(position_common_ColorBackground);
      }
      // ドテンボタン
      if(
         m_position_menu_main_doten_panel.Left() <= x && 
         m_position_menu_main_doten_panel.Left() + m_position_menu_main_doten_panel.Width() >= x &&
         m_position_menu_main_doten_panel.Top() <= y && 
         m_position_menu_main_doten_panel.Top() + m_position_menu_main_doten_panel.Height() >= y
      ){
         if(m_position_menu_main_doten_panel.ColorBackground() == position_common_ColorBackground){
            m_position_menu_main_doten_panel.ColorBackground(position_menu_active_ColorBackground);
         }
      }else if(m_position_menu_main_doten_panel.ColorBackground() == position_menu_active_ColorBackground){
         m_position_menu_main_doten_panel.ColorBackground(position_common_ColorBackground);
      }
      // %決済ボタン
      if(!m_position_menu_main_percent_input.IsVisible()){
         if(
            m_position_menu_main_percent_exit_menu_panel.Left() <= x && 
            m_position_menu_main_percent_exit_menu_panel.Left() + m_position_menu_main_percent_exit_menu_panel.Width() >= x &&
            m_position_menu_main_percent_exit_menu_panel.Top() <= y && 
            m_position_menu_main_percent_exit_menu_panel.Top() + m_position_menu_main_percent_exit_menu_panel.Height() >= y
         ){
            if(m_position_menu_main_percent_exit_menu_panel.ColorBackground() == position_common_ColorBackground){
               m_position_menu_main_percent_exit_menu_panel.ColorBackground(position_menu_active_ColorBackground);
            }
         }else if(m_position_menu_main_percent_exit_menu_panel.ColorBackground() == position_menu_active_ColorBackground){
            m_position_menu_main_percent_exit_menu_panel.ColorBackground(position_common_ColorBackground);
         }
      }
      // SL建値ボタン
      if(
         m_position_menu_main_sltatene_panel.Left() <= x && 
         m_position_menu_main_sltatene_panel.Left() + m_position_menu_main_sltatene_panel.Width() >= x &&
         m_position_menu_main_sltatene_panel.Top() <= y && 
         m_position_menu_main_sltatene_panel.Top() + m_position_menu_main_sltatene_panel.Height() >= y
      ){
         if(m_position_menu_main_sltatene_panel.ColorBackground() == position_common_ColorBackground){
            m_position_menu_main_sltatene_panel.ColorBackground(position_menu_active_ColorBackground);
         }
      }else if(m_position_menu_main_sltatene_panel.ColorBackground() == position_menu_active_ColorBackground){
         m_position_menu_main_sltatene_panel.ColorBackground(position_common_ColorBackground);
      }
      // 自動SL建値ボタン
      if(!m_position_menu_sub_trailingstop_targetpips.IsVisible()){
         if(
            m_position_menu_main_trailingstop_menu_panel.Left() <= x && 
            m_position_menu_main_trailingstop_menu_panel.Left() + m_position_menu_main_trailingstop_menu_panel.Width() >= x &&
            m_position_menu_main_trailingstop_menu_panel.Top() <= y && 
            m_position_menu_main_trailingstop_menu_panel.Top() + m_position_menu_main_trailingstop_menu_panel.Height() >= y
         ){
            if(m_position_menu_main_trailingstop_menu_panel.ColorBackground() == position_common_ColorBackground){
               m_position_menu_main_trailingstop_menu_panel.ColorBackground(position_menu_active_ColorBackground);
            }
         }else if(m_position_menu_main_trailingstop_menu_panel.ColorBackground() == position_menu_active_ColorBackground){
            m_position_menu_main_trailingstop_menu_panel.ColorBackground(position_common_ColorBackground);
         }
      }
      // TPSL設定ボタン
      if(!m_position_menu_main_tpsl_tp_input.IsVisible()){
         if(
            m_position_menu_main_tpsl_menu_panel.Left() <= x && 
            m_position_menu_main_tpsl_menu_panel.Left() + m_position_menu_main_tpsl_menu_panel.Width() >= x &&
            m_position_menu_main_tpsl_menu_panel.Top() <= y && 
            m_position_menu_main_tpsl_menu_panel.Top() + m_position_menu_main_tpsl_menu_panel.Height() >= y
         ){
            if(m_position_menu_main_tpsl_menu_panel.ColorBackground() == position_common_ColorBackground){
               m_position_menu_main_tpsl_menu_panel.ColorBackground(position_menu_active_ColorBackground);
            }
         }else if(m_position_menu_main_tpsl_menu_panel.ColorBackground() == position_menu_active_ColorBackground){
            m_position_menu_main_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
         }
      }
      // MA TPSL設定ボタン
      if(!m_position_menu_sub_ma_tp_period.IsVisible()){
         if(
            m_position_menu_main_ma_tpsl_menu_panel.Left() <= x && 
            m_position_menu_main_ma_tpsl_menu_panel.Left() + m_position_menu_main_ma_tpsl_menu_panel.Width() >= x &&
            m_position_menu_main_ma_tpsl_menu_panel.Top() <= y && 
            m_position_menu_main_ma_tpsl_menu_panel.Top() + m_position_menu_main_ma_tpsl_menu_panel.Height() >= y
         ){
            if(m_position_menu_main_ma_tpsl_menu_panel.ColorBackground() == position_common_ColorBackground){
               m_position_menu_main_ma_tpsl_menu_panel.ColorBackground(position_menu_active_ColorBackground);
            }
         }else if(m_position_menu_main_ma_tpsl_menu_panel.ColorBackground() == position_menu_active_ColorBackground){
            m_position_menu_main_ma_tpsl_menu_panel.ColorBackground(position_common_ColorBackground);
         }
      }
   }
   //--- succeed
   return(true);
}

bool CSettingsDialog::RefreshControls(void)
  {
   if(!CreateAndUpdatePositionObjects())
      return(false);
   
   AdjustStoplineLabelsXY();
   
   //---
   static double lastEntryPrice=0;   
   double entryPrice=GetPriceBySRLine(GetSelectedSRLineName());
   
   if(lastEntryPrice!=entryPrice)
     {
      lastEntryPrice=entryPrice;
      
      OnMoveEntryLine();      
     }
   
   //--- Adjust display info's position
   ObjectSetString(0,LABEL_CANDLETIME_NAME,OBJPROP_TEXT,calcCandleTime());
   
   int candleTimeHeight=(int)ObjectGetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_YSIZE);
   if(candleTimeHeight>0)
     {
      ObjectSetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_YDISTANCE,ObjectGetInteger(0,LABEL_CANDLETIME_NAME,OBJPROP_YDISTANCE)+candleTimeHeight+10);
     }     
   int maTpSlInfoHeight=(int)ObjectGetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_YSIZE);   
   if(maTpSlInfoHeight>0)
     {
      ObjectSetInteger(0,LABEL_TRAILINGSTOP_INFO_NAME,OBJPROP_YDISTANCE,ObjectGetInteger(0,LABEL_MA_TPSL_INFO_NAME,OBJPROP_YDISTANCE)+maTpSlInfoHeight+10);
     }
           
   return(true);   
  }  
  
void CSettingsDialog::AdjustStoplineLabelsXY()
  {
   double entryPrice=ObjectGetDouble(0,HLINE_ENTRY_NAME,OBJPROP_PRICE);
   double tpPrice=ObjectGetDouble(0,HLINE_TP_NAME,OBJPROP_PRICE);
   double slPrice=ObjectGetDouble(0,HLINE_SL_NAME,OBJPROP_PRICE);
   
   double tpPips=0, slPips=0;
   
   string selOdrTypeStr=m_combox_OrderType.Select();
         
   if(StringFind(selOdrTypeStr,"Buy")!=-1)
     {
      tpPips=(tpPrice-entryPrice)/_Pips;
      slPips=(entryPrice-slPrice)/_Pips;
     }
   else if(StringFind(selOdrTypeStr,"Sell")!=-1)
     {
      tpPips=(entryPrice-tpPrice)/_Pips;
      slPips=(slPrice-entryPrice)/_Pips;
     }
        
   datetime time=0;
   int x, y;
   ChartTimePriceToXY(0,0,time,entryPrice,x,y);
   ObjectSetInteger(0,LABEL_ENTRY_NAME,OBJPROP_YDISTANCE,y-LABEL_HEIGHT);   
   ChartTimePriceToXY(0,0,time,tpPrice,x,y);
   ObjectSetInteger(0,LABEL_TP_NAME,OBJPROP_YDISTANCE,y-LABEL_HEIGHT);
   ObjectSetString(0,LABEL_TP_NAME,OBJPROP_TEXT,"TP "+DoubleToString(tpPips,1));
   ChartTimePriceToXY(0,0,time,slPrice,x,y);
   ObjectSetInteger(0,LABEL_SL_NAME,OBJPROP_YDISTANCE,y-LABEL_HEIGHT); 
   ObjectSetString(0,LABEL_SL_NAME,OBJPROP_TEXT,"SL "+DoubleToString(slPips,1));
  }  
//////////////////////////////////////////////////////////////////////////////////////////////////////

CSettingsDialog ExtDialog;

double   _Pips;
MqlTick  _LastTick;     // To be used for getting recent/latest price quotes

char     _TrendlineHotkey;
char     _HorizonlineHotkey;

struct IndicatorMA
  {
   IndicatorMA()
      : handle(INVALID_HANDLE)      
      , timeframe(0)
      , period(20)
      , method(MODE_SMA)
     {}
     
   int               handle;
   ENUM_TIMEFRAMES   timeframe;   
   int               period;
   ENUM_MA_METHOD    method;
  };
  
IndicatorMA _IndMAs[];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {  
   // 許可している口座か
   if(!chkTradeAccount())
     {
       printf("Error Account Error");
       return(INIT_FAILED);
     }
//---
   CreateQuickTradingButtons();
//---
   int dialogAxisX=-1, dialogAxisY=-1;
   if(GlobalVariableCheck(GV_SAL_DIALOG_AXISX) &&
      GlobalVariableCheck(GV_SAL_DIALOG_AXISY))
     {
      dialogAxisX=(int)GlobalVariableGet(GV_SAL_DIALOG_AXISX);
      dialogAxisY=(int)GlobalVariableGet(GV_SAL_DIALOG_AXISY);
     }
   
   int chartWidth = (int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
   int chartHeight = (int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
   int axisX = (dialogAxisX == -1 || dialogAxisX+DIALOG_WIDTH>chartWidth) ? 0 : dialogAxisX;
   int axisY = (dialogAxisY == -1 || dialogAxisY+DIALOG_HEIGHT>chartHeight) ? MathMax(0,chartHeight-DIALOG_HEIGHT) : dialogAxisY;
   
   if(!ExtDialog.Create(0,CAPTION_NAME,0,axisX,axisY,axisX+DIALOG_WIDTH,axisY+DIALOG_HEIGHT))
      return(INIT_FAILED);
//--- run application
   ExtDialog.Run();
//---
   _Pips=SymbolInfoDouble(NULL,SYMBOL_POINT)*10;
   
   string trlineHotkey=StringSubstr(InpTrendlineHotkey,0,1);
   string hlineHotkey=StringSubstr(InpHorizonlineHotkey,0,1);   
   StringToUpper(trlineHotkey);
   StringToUpper(hlineHotkey);
   
   _TrendlineHotkey=(char)StringGetCharacter(trlineHotkey,0);
   _HorizonlineHotkey=(char)StringGetCharacter(hlineHotkey,0);
//--- create timer
   EventSetMillisecondTimer(250);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ExtDialog.Destroy(reason);
//---
   ObjectsDeleteAll(0,OBJ_NAME_PREFIX);   
//--- destroy timer
   EventKillTimer();
//---
   for(int i=0;i<ArraySize(_IndMAs);i++)
     {
      if(_IndMAs[i].handle!=INVALID_HANDLE)
        {
         IndicatorRelease(_IndMAs[i].handle);
         _IndMAs[i].handle=INVALID_HANDLE;
        }
     }
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(!SymbolInfoTick(_Symbol,_LastTick))
   {
      Alert("Error getting the latest price quote - error:",GetLastError(),"!!");
      ResetLastError();
      return;
   }
//---
   ExtDialog.OnTick();
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   CheckOnOffQuickTradingButtons();
//---
   ExtDialog.RefreshControls();
   
   ExtDialog.OnTick();
   
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   static char  hotkeyPressed;
   static int   firstClicked=false;
   
   if(id==CHARTEVENT_KEYDOWN)
     {
      if(lparam==_TrendlineHotkey || lparam==_HorizonlineHotkey || lparam=='X')
        {
         hotkeyPressed=(char)lparam;
         Print("Hotkey: ",CharToString(hotkeyPressed)," pressed!");
         
         if(lparam=='X')
           {
            if(ExtDialog.IsVisible())
               ExtDialog.Hide();
            else
               ExtDialog.Show();  
           }
        }
      else
        {
         hotkeyPressed='-';  
        }
         
      //---
      if(firstClicked)
        {
         firstClicked=false;
         
         string lineObjName=GetNextTrendlineName(true);
         ObjectDelete(0,lineObjName);
        }   
     }  
//---
   if(id==CHARTEVENT_CLICK)
     {
      //---
      int x=(int)lparam;
      int y=(int)dparam;
      
      //if(x<ExtDialog.Left() || x>ExtDialog.Right() ||
         //y<ExtDialog.Top() || y>ExtDialog.Bottom())
      
      if(hotkeyPressed==_TrendlineHotkey)
        {
         if(!firstClicked)
           {
            firstClicked=true;
            
            //---
            string lineObjName=GetNextTrendlineName();
            
            int      subWnd;
            datetime time;
            double   price;
            ChartXYToTimePrice(0,x,y,subWnd,time,price);
                        
            ObjectCreate(0,lineObjName,OBJ_TREND,0,time,price);
            ObjectSetInteger(0,lineObjName,OBJPROP_SELECTABLE,true);
            ObjectSetInteger(0,lineObjName,OBJPROP_SELECTED,true);
           }  
         else
           {
            firstClicked=false;
            hotkeyPressed='-';
            
            //---
            string lineObjName=GetNextTrendlineName(true);
            
            int      subWnd;
            datetime time;
            double   price;
            ChartXYToTimePrice(0,x,y,subWnd,time,price);
                        
            ObjectSetInteger(0,lineObjName,OBJPROP_TIME,1,time);
            ObjectSetDouble(0,lineObjName,OBJPROP_PRICE,1,price);
            
            ExtDialog.OnCreateSRLine(lineObjName);
            
            AdjustOdrTextXYBySRLine(lineObjName);
           }
        }
      else if(hotkeyPressed==_HorizonlineHotkey)
        {
         hotkeyPressed='-';
         
         //---
         int subWnd;
         datetime time;
         double price;
         ChartXYToTimePrice(0,x,y,subWnd,time,price);
         
         string lineObjName=GetNextHorizonlineName();
         
         ObjectCreate(0,lineObjName,OBJ_HLINE,0,time,price);
         ObjectSetInteger(0,lineObjName,OBJPROP_SELECTABLE,true);
         ObjectSetInteger(0,lineObjName,OBJPROP_SELECTED,true);
        }  
     }
   else if(id==CHARTEVENT_MOUSE_MOVE)
     {
      if(hotkeyPressed==_TrendlineHotkey && firstClicked)
        {
         int x=(int)lparam;
         int y=(int)dparam;
         
         //---
         string lineObjName=GetNextTrendlineName(true);
         
         int      subWnd;
         datetime time;
         double   price;
         ChartXYToTimePrice(0,x,y,subWnd,time,price);
                     
         ObjectSetInteger(0,lineObjName,OBJPROP_TIME,1,time);
         ObjectSetDouble(0,lineObjName,OBJPROP_PRICE,1,price);
        }
     }  
   
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Handle quick trading button event
      if(StringFind(sparam,"QuickTrade")!=-1)
        {
         ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
         ChartRedraw();
         
         if(sparam==OBJ_NAME_PREFIX+"QuickTrade_CloseAll")
           {
            ExtDialog.OnClickButton_CloseAll();
           }
         if(sparam==OBJ_NAME_PREFIX+"QuickTrade_CloseBuy")
           {
            ExtDialog.OnClickButton_CloseBuy();
           }
         if(sparam==OBJ_NAME_PREFIX+"QuickTrade_CloseSell")
           {
            ExtDialog.OnClickButton_CloseSell();
           }
        }      
      // ポジションメニュー表示
      if(StringFind(sparam, POSITION_NAME_PREFIX + "_button_") == 0){
         ExtDialog.CreatePositionMenu((int)lparam, (int)dparam, sparam);
      }
      // tp削除
      if(StringFind(sparam, POSITION_TP_NAME_PREFIX) == 0){
         ExtDialog.RemovePositionTp((int)lparam, (int)dparam, sparam);
      }
      // sl削除
      if(StringFind(sparam, POSITION_SL_NAME_PREFIX) == 0){
         ExtDialog.RemovePositionSl((int)lparam, (int)dparam, sparam);
      }
      // order削除
      if(StringFind(sparam, POSITION_ORDER_NAME_PREFIX) == 0){
         ExtDialog.RemoveOrder((int)lparam, (int)dparam, sparam);
      }

      //--- Handle position menu event
      if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_close")==0)
        {
         ExtDialog.OnPositionMenuClose();
        }
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_exit")==0)
        {
         ExtDialog.OnPositionMenuExit();
        }
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_doten")==0)
        {
         ExtDialog.OnPositionMenuDoten();
        } 
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_percent_exit_menu")==0)
        {
         ExtDialog.OnPositionMenuPercentMenu();
        } 
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_sltatene")==0)
        {
         ExtDialog.OnPositionMenuSlTatene();
        }
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_trailingstop_menu")==0)
        {
         ExtDialog.OnPositionMenuTrailingStopMenu();
        }    
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_tpsl_menu")==0)
        {
         ExtDialog.OnPositionMenuTpSlMenu();
        }
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_ma_tpsl_menu")==0)
        {
         ExtDialog.OnPositionMenuMATpSlMenu();
        }          
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_exit_panel")==0)
        {
         ExtDialog.OnPositionMenuExit();
        } 
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_doten_panel")==0)
        {
         ExtDialog.OnPositionMenuDoten();
        } 
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_percent_exit_menu_panel")==0)
        {
         ExtDialog.OnPositionMenuPercentMenu();
        }
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_sltatene_panel")==0)
        {
         ExtDialog.OnPositionMenuSlTatene();
        } 
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_tpsl_menu_panel")==0)
        {
         ExtDialog.OnPositionMenuTpSlMenu();
        } 
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_percent_exit")==0)
        {
         ExtDialog.OnPositionMenuExitExec();
        }
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"sub_trailingstop_set")==0)
        {
         ExtDialog.OnPositionMenuTrailingStopSet();
        }
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"menu_main_tpsl")==0)
        {
         ExtDialog.OnPositionMenuTpSlExec();
        }  
      /*else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_tp_chk")==0 ||
         StringFind(sparam,POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_sl_chk")==0)
        {
         ExtDialog.OnPositionMenuMATpSlCheck(sparam);
        }*/  
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_tp_method")==0 ||
         StringFind(sparam,POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_sl_method")==0)
        {
         ExtDialog.OnPositionMenuMATpSlMethod(sparam);
        }
      else if(StringFind(sparam,POSITION_MENU_NAME_PREFIX+"sub_ma_tpsl_set")==0)
        {
         ExtDialog.OnPositionMenuMATpSlSet();
        }  
        
      //--- Select trendline or horizontal line
      static ulong lastClickTime=0;
      
      if((OBJ_TREND==(ENUM_OBJECT)ObjectGetInteger(0,sparam,OBJPROP_TYPE) && StringFind(sparam,"Trendline")!=-1) ||
         (OBJ_HLINE==(ENUM_OBJECT)ObjectGetInteger(0,sparam,OBJPROP_TYPE) && StringFind(sparam,"Horizontal")!=-1))
        {
         ulong clickTime = GetTickCount();
         if(clickTime < lastClickTime + DoubleClickDelayMillis)
           {
            //Print("Trendline DoubleClick!");
            lastClickTime = 0;
            
            if ((bool)ObjectGetInteger(0,sparam,OBJPROP_SELECTED))   
              {
               ExtDialog.OnSelectSRLine(sparam);
              }
            else
              {
               ExtDialog.OnDeselectSRLine(sparam);
              }  
           }
         else
           {
            lastClickTime = clickTime;
           }
        }     
        
      //--- Bring to top
      if(StringFind(sparam, "Caption")!=-1)
        {
         ExtDialog.Hide();
         ExtDialog.Show();
        }
     }
   else if(id==CHARTEVENT_OBJECT_CREATE)
     {
      if((OBJ_TREND==(ENUM_OBJECT)ObjectGetInteger(0,sparam,OBJPROP_TYPE) &&
         StringFind(sparam,"Trendline")!=-1 && !firstClicked) ||
         (OBJ_HLINE==(ENUM_OBJECT)ObjectGetInteger(0,sparam,OBJPROP_TYPE) &&
         StringFind(sparam,"Horizontal")!=-1))
        {
         ExtDialog.OnCreateSRLine(sparam);
        }
     }    
   else if(id==CHARTEVENT_OBJECT_DELETE)
     {
      //if(OBJ_TREND==(ENUM_OBJECT)ObjectGetInteger(0,sparam,OBJPROP_TYPE))
      if((StringFind(sparam,"Trendline")!=-1 && StringFind(sparam,LABEL_ODR_TEXT_NAME_PREFIX)<0 && StringFind(sparam,LABEL_ODR_STATE_NAME_PREFIX)<0) ||
         StringFind(sparam,"Horizontal")!=-1)   
        {
         ExtDialog.OnDeleteSRLine(sparam);
        }
     }  
   else if(id==CHARTEVENT_OBJECT_CHANGE || id==CHARTEVENT_OBJECT_DRAG)
     {
      if(OBJ_TREND==(ENUM_OBJECT)ObjectGetInteger(0,sparam,OBJPROP_TYPE) ||
        (OBJ_HLINE==(ENUM_OBJECT)ObjectGetInteger(0,sparam,OBJPROP_TYPE) && StringFind(sparam,"Horizontal")!=-1))
        {
         ExtDialog.OnChangeSRLine(sparam);
        }
      else if(OBJ_HLINE==(ENUM_OBJECT)ObjectGetInteger(0,sparam,OBJPROP_TYPE))
        {
         ExtDialog.OnMoveStopLine(sparam);
        }  
     }
   else if(id==CHARTEVENT_CHART_CHANGE)
     {
      for(int i=ObjectsTotal(0)-1;i>=0;i--)
        {
         string objName=ObjectName(0,i);
         if(OBJ_TREND==(ENUM_OBJECT)ObjectGetInteger(0,objName,OBJPROP_TYPE) ||
            OBJ_HLINE==(ENUM_OBJECT)ObjectGetInteger(0,objName,OBJPROP_TYPE))
           {
            AdjustOdrTextXYBySRLine(objName);
           }
        }
      
      ExtDialog.AdjustStoplineLabelsXY();
     }
   // オンマウスで色変換の検知用
   else if(id == CHARTEVENT_MOUSE_MOVE)
     {
      ExtDialog.ChkOnMouse((int)lparam, (int)dparam, sparam);
     }  
   
//---
   ExtDialog.ChartEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+  
void AdjustOdrTextXYBySRLine(string lineObjName)
  {
   datetime time1=(datetime)ObjectGetInteger(0,lineObjName,OBJPROP_TIME,0);
   datetime time2=(datetime)ObjectGetInteger(0,lineObjName,OBJPROP_TIME,1);
   double price1=ObjectGetDouble(0,lineObjName,OBJPROP_PRICE,0);
   double price2=ObjectGetDouble(0,lineObjName,OBJPROP_PRICE,1);
   
   string odrTextObjName=LABEL_ODR_TEXT_NAME_PREFIX+lineObjName;
   string odrStateObjName=LABEL_ODR_STATE_NAME_PREFIX+lineObjName;
   
   if(OBJ_TREND==(ENUM_OBJECT)ObjectGetInteger(0,lineObjName,OBJPROP_TYPE))
     {
      int x1,x2;
      int y1,y2;
      ChartTimePriceToXY(0,0,time1,price1,x1,y1);
      ChartTimePriceToXY(0,0,time2,price2,x2,y2);
      
      double base    = x2-x1;
      double height = y1-y2;
      double degrees = base==0 ? 0 : MathArctan(height/base)*(360/(2*M_PI));  
   
      ObjectSetInteger(0,odrTextObjName,OBJPROP_ANCHOR,degrees>0? ANCHOR_LEFT_UPPER : ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0,odrTextObjName,OBJPROP_TIME,time1);
      ObjectSetDouble(0,odrTextObjName,OBJPROP_PRICE,price1);
      ObjectSetDouble(0,odrTextObjName,OBJPROP_ANGLE,degrees);
      ObjectSetInteger(0,odrStateObjName,OBJPROP_ANCHOR,degrees<=0? ANCHOR_LEFT_UPPER : ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0,odrStateObjName,OBJPROP_TIME,time1);
      ObjectSetDouble(0,odrStateObjName,OBJPROP_PRICE,price1);
      ObjectSetDouble(0,odrStateObjName,OBJPROP_ANGLE,degrees);  
     }
   else if(OBJ_HLINE==(ENUM_OBJECT)ObjectGetInteger(0,lineObjName,OBJPROP_TYPE))
     {
      datetime time=iTime(NULL,0,(int)ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR));
      
      ObjectSetInteger(0,odrTextObjName,OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0,odrTextObjName,OBJPROP_TIME,time);
      ObjectSetDouble(0,odrTextObjName,OBJPROP_PRICE,price1);
      //ObjectSetDouble(0,odrTextObjName,OBJPROP_ANGLE,degrees);
      ObjectSetInteger(0,odrStateObjName,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
      ObjectSetInteger(0,odrStateObjName,OBJPROP_TIME,time);
      ObjectSetDouble(0,odrStateObjName,OBJPROP_PRICE,price1);
      //ObjectSetDouble(0,odrStateObjName,OBJPROP_ANGLE,degrees); 
     }
  }
  
double GetPriceBySRLine(string lineObjName, datetime time=NULL)
  {
   double price=0.0f;
   
   if(OBJ_TREND==(ENUM_OBJECT)ObjectGetInteger(0,lineObjName,OBJPROP_TYPE))
     {
      datetime time1=(datetime)ObjectGetInteger(0,lineObjName,OBJPROP_TIME,0);
      datetime time2=(datetime)ObjectGetInteger(0,lineObjName,OBJPROP_TIME,1);
      double price1=ObjectGetDouble(0,lineObjName,OBJPROP_PRICE,0);
      double price2=ObjectGetDouble(0,lineObjName,OBJPROP_PRICE,1);
      
      time=time==NULL?iTime(NULL,0,0):time;
      price=price1+((time2-time1)==0 ? 0 : (price2-price1)*(double)(time-time1)/(time2-time1));
      /*int x1,x2;
      int y1,y2;
      ChartTimePriceToXY(0,0,time1,price1,x1,y1);
      ChartTimePriceToXY(0,0,time2,price2,x2,y2);
      
      time=time==NULL?iTime(NULL,0,0):time;
      double   price=0;
      
      int x,y;
      ChartTimePriceToXY(0,0,time,0,x,y);
      
      y=(x2-x1==0) ? 0 : (int)(y1-(y1-y2)*(double)(x-x1)/(x2-x1));
      
      int subWnd;
      ChartXYToTimePrice(0,x,y,subWnd,time,price);*/
      //ObjectCreate(0,"xLine",OBJ_HLINE,0,0,price);
     }   
   else if(OBJ_HLINE==(ENUM_OBJECT)ObjectGetInteger(0,lineObjName,OBJPROP_TYPE))
     {
      price=ObjectGetDouble(0,lineObjName,OBJPROP_PRICE);
     }
     
   return(price);
  }
  
string GetNextTrendlineName(bool returnLastLineName=false)
  {
   static ulong curLineNum=0;
   
   while(!returnLastLineName && ObjectFind(0,"Trendline "+IntegerToString(curLineNum))>=0)
      curLineNum++;
        
   return("Trendline "+IntegerToString(curLineNum));
  }
  
string GetNextHorizonlineName()
  {
   static ulong curLineNum=0;
   
   while(ObjectFind(0,"Horizontal Line "+IntegerToString(curLineNum))>=0)
      curLineNum++;
        
   return("Horizontal Line "+IntegerToString(curLineNum));
  }  
  
int getNonDuplicateY(int y, int h){
   y -= h;
   y = chkDuplicateY(y, h);

   ArrayResize(position_label_ys, ArraySize(position_label_ys)+1);
   position_label_ys[ArraySize(position_label_ys)-1] = y;

   return y;
}

int chkDuplicateY(int y, int h){
   for(int i=0;i<ArraySize(position_label_ys);i++){
      if(
         y+h > position_label_ys[i] &&
         position_label_ys[i]+h > y
      ){
         y = position_label_ys[i]+h;
         return chkDuplicateY(y, h);
      }
   }

   return y;
}  

double calcCloseLotToPercent(double volume, int percent){
   if(percent>=100)
      return volume;
   // 証拠金の%損失で計算する
   double min_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   volume = volume * percent / 100;
   volume = MathFloor(volume / min_lot) * min_lot;
   if(volume < min_lot)
   {
      volume = min_lot;
   }

   return volume;
}

string calcCandleTime(){
   MqlDateTime beforeDt;
   MqlDateTime nextDt;
   datetime lastTime = iTime(_Symbol, 0, 0);
   datetime now = TimeCurrent();
   datetime nextTime;
   int h, d;
   switch(_Period){
      case PERIOD_M1:
      case PERIOD_M2:
      case PERIOD_M3:
      case PERIOD_M4:
      case PERIOD_M5:
      case PERIOD_M6:
      case PERIOD_M10:
      case PERIOD_M12:
      case PERIOD_M15:
      case PERIOD_M20:
      case PERIOD_M30:
         // 直近のローソクに分を加算する
         nextTime = lastTime + _Period * 60;
         break;
      case PERIOD_H1:
         h = 1;
         // 直近のローソクに時を加算する
         nextTime = lastTime + h * 60 * 60;
         break;
      case PERIOD_H2:
         h = 2;
         // 直近のローソクに時を加算する
         nextTime = lastTime + h * 60 * 60;
         break;
      case PERIOD_H3:
         h = 3;
         // 直近のローソクに時を加算する
         nextTime = lastTime + h * 60 * 60;
         break;
      case PERIOD_H4:
         h = 4;
         // 直近のローソクに時を加算する
         nextTime = lastTime + h * 60 * 60;
         break;
      case PERIOD_H6:
         h = 6;
         // 直近のローソクに時を加算する
         nextTime = lastTime + h * 60 * 60;
         break;
      case PERIOD_H8:
         h = 8;
         // 直近のローソクに時を加算する
         nextTime = lastTime + h * 60 * 60;
         break;
      case PERIOD_H12:
         h = 12;
         // 直近のローソクに時を加算する
         nextTime = lastTime + h * 60 * 60;
         break;
      case PERIOD_D1:
         d = 1;
         // 直近のローソクに日を加算する
         nextTime = lastTime + 24 * 60 * 60;
         break;
      case PERIOD_W1:
         d = 7;
         // 直近のローソクに日を加算する
         nextTime = lastTime + 7 * 24 * 60 * 60;
         break;
      case PERIOD_MN1:
         // 直近のローソクに日を加算する
         TimeToStruct(lastTime, beforeDt);
         if(beforeDt.mon < 12){
            beforeDt.mon=beforeDt.mon+1;
         }else{
            beforeDt.year=beforeDt.year+1;
            beforeDt.mon=1;
         }
         nextTime = StructToTime(beforeDt);
         break;
   }

   if(nextTime-now <= 0){
      return "00:00:00";
   }

   MqlDateTime returnDt;
   TimeToStruct(nextTime-now, returnDt);
   // printf("%4d-%02d-%02d %02d:%02d:%02d",returnDt.year,returnDt.mon,returnDt.day,returnDt.hour,returnDt.min,returnDt.sec);

   if(returnDt.day>1){
      // 1日以上
      return StringFormat("%dd %dh",returnDt.day-1,returnDt.hour);
   }else{
      return StringFormat("%02d:%02d:%02d",returnDt.hour,returnDt.min,returnDt.sec);
   }
   
}

int StringToEnumTLOrderType(string str)
  {
   int val=BuyTouch;
   
   if(str=="Buy.T")           val=BuyTouch;   
   else if(str=="Sell.T")     val=SellTouch;
   else if(str=="Buy.BRK")    val=BuyBreakout;
   else if(str=="Sell.BRK")   val=SellBreakout;
   else if(str=="Buy.PB")     val=BuyPullback;
   else if(str=="Sell.PB")    val=SellPullback;
   else if(str=="Buy.RR")     val=BuyRoleReversal;
   else if(str=="Sell.RR")    val=SellRoleReversal;
   
   return(val);
  }
  
string EnumTLOrderTypeToString(ENUM_TL_ORDER_TYPE val)
  {
   string str;
   
   if(val==BuyTouch)                str="Buy.T";
   else if(val==SellTouch)          str="Sell.T";
   else if(val==BuyBreakout)        str="Buy.BRK";
   else if(val==SellBreakout)       str="Sell.BRK";
   else if(val==BuyPullback)        str="Buy.PB";
   else if(val==SellPullback)       str="Sell.PB";
   else if(val==BuyRoleReversal)    str="Buy.RR";
   else if(val==SellRoleReversal)   str="Sell.RR";
   
   return(str);
  }  
  
bool chkTradeAccount()
  {
   if(!accountControlEnable)
     {
      return true;
     }
   int account_no = (int)AccountInfoInteger(ACCOUNT_LOGIN);
   int Size=ArraySize(accountList);
   for(int i=0;i<Size;i++)
     {
      if(accountList[i]==account_no)
         return true;
     }
   return false;
  }
  
  
bool CreateQuickTradingButtons()
  {
   string btnObjName_CloseAll=OBJ_NAME_PREFIX+"QuickTrade_CloseAll";
   string btnObjName_CloseBuy=OBJ_NAME_PREFIX+"QuickTrade_CloseBuy";
   string btnObjName_CloseSell=OBJ_NAME_PREFIX+"QuickTrade_CloseSell";
   
   if(!ObjectCreate(0,btnObjName_CloseAll,OBJ_BUTTON,0,0,0))
      return(false);
   if(!ObjectCreate(0,btnObjName_CloseBuy,OBJ_BUTTON,0,0,0))
      return(false);
   if(!ObjectCreate(0,btnObjName_CloseSell,OBJ_BUTTON,0,0,0))
      return(false);
            
   ObjectSetInteger(0,btnObjName_CloseAll,OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,btnObjName_CloseAll,OBJPROP_YDISTANCE,80);
   ObjectSetInteger(0,btnObjName_CloseAll,OBJPROP_XSIZE,BUTTON_WIDTH);
   ObjectSetInteger(0,btnObjName_CloseAll,OBJPROP_YSIZE,BUTTON_HEIGHT);
   ObjectSetInteger(0,btnObjName_CloseAll,OBJPROP_BORDER_COLOR,clrBlack);
   ObjectSetInteger(0,btnObjName_CloseAll,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,btnObjName_CloseAll,OBJPROP_BACK,false);
   ObjectSetString(0,btnObjName_CloseAll,OBJPROP_TEXT,"Close All");
   
   ObjectSetInteger(0,btnObjName_CloseBuy,OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,btnObjName_CloseBuy,OBJPROP_YDISTANCE,105);
   ObjectSetInteger(0,btnObjName_CloseBuy,OBJPROP_XSIZE,BUTTON_WIDTH);
   ObjectSetInteger(0,btnObjName_CloseBuy,OBJPROP_YSIZE,BUTTON_HEIGHT);
   ObjectSetInteger(0,btnObjName_CloseBuy,OBJPROP_BORDER_COLOR,clrBlack);
   ObjectSetInteger(0,btnObjName_CloseBuy,OBJPROP_BGCOLOR,C'124,188,54');
   ObjectSetInteger(0,btnObjName_CloseBuy,OBJPROP_COLOR,clrBlack);
   ObjectSetInteger(0,btnObjName_CloseBuy,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,btnObjName_CloseBuy,OBJPROP_BACK,false);
   ObjectSetString(0,btnObjName_CloseBuy,OBJPROP_TEXT,"Close Buy");
   
   ObjectSetInteger(0,btnObjName_CloseSell,OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,btnObjName_CloseSell,OBJPROP_YDISTANCE,130);
   ObjectSetInteger(0,btnObjName_CloseSell,OBJPROP_XSIZE,BUTTON_WIDTH);
   ObjectSetInteger(0,btnObjName_CloseSell,OBJPROP_YSIZE,BUTTON_HEIGHT);
   ObjectSetInteger(0,btnObjName_CloseSell,OBJPROP_BORDER_COLOR,clrBlack);
   ObjectSetInteger(0,btnObjName_CloseSell,OBJPROP_BGCOLOR,C'204,60,68');
   ObjectSetInteger(0,btnObjName_CloseSell,OBJPROP_COLOR,clrBlack);
   ObjectSetInteger(0,btnObjName_CloseSell,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ObjectSetInteger(0,btnObjName_CloseSell,OBJPROP_BACK,false);
   ObjectSetString(0,btnObjName_CloseSell,OBJPROP_TEXT,"Close Sell");
   
   return(true);
  }

void CheckOnOffQuickTradingButtons()
  {
   string btnObjName_CloseAll=OBJ_NAME_PREFIX+"QuickTrade_CloseAll";
   string btnObjName_CloseBuy=OBJ_NAME_PREFIX+"QuickTrade_CloseBuy";
   string btnObjName_CloseSell=OBJ_NAME_PREFIX+"QuickTrade_CloseSell";
   
   if((bool)ChartGetInteger(0,CHART_SHOW_ONE_CLICK))
     {
      ObjectSetInteger(0,btnObjName_CloseAll,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetInteger(0,btnObjName_CloseBuy,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
      ObjectSetInteger(0,btnObjName_CloseSell,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
     }  
   else
     {
      ObjectSetInteger(0,btnObjName_CloseAll,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      ObjectSetInteger(0,btnObjName_CloseBuy,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      ObjectSetInteger(0,btnObjName_CloseSell,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
     }
  }
  
int FirstOrCreateMAIndicator(ENUM_TIMEFRAMES timeframe, int period, ENUM_MA_METHOD method)
  {
   int idx=-1;
   
   int indMAsTotal=ArraySize(_IndMAs);
   for(int i=0;i<indMAsTotal;i++)
     {
      if(_IndMAs[i].timeframe==timeframe &&
         _IndMAs[i].period==period &&
         _IndMAs[i].method==method)
        {
         idx=i;
         break;
        }
     }
     
   if(idx==-1)
     {
      ArrayResize(_IndMAs,++indMAsTotal,10);      
      _IndMAs[indMAsTotal-1].timeframe=timeframe;
      _IndMAs[indMAsTotal-1].period=period;
      _IndMAs[indMAsTotal-1].method=method;      
      
      idx=indMAsTotal-1;
     }
     
   if(_IndMAs[idx].handle==INVALID_HANDLE)
     {
      int handle=iMA(NULL,0,_IndMAs[idx].period,0,_IndMAs[idx].method,PRICE_CLOSE);
      if(handle==INVALID_HANDLE) 
        { 
         //--- tell about the failure and output the error code 
         PrintFormat("Failed to create handle of the iMA indicator for the symbol %s/%s, error code %d", 
                     _Symbol, 
                     EnumToString(PERIOD_CURRENT), 
                     GetLastError());   
        }
        
      _IndMAs[idx].handle=handle;
     }
   
   return _IndMAs[idx].handle;  
  }
  
string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,16385,16388,16408,32769,49153};

int str2tf(string tfs)
{
   StringToUpper(tfs);
   for (int i=ArraySize(iTfTable)-1; i>=0; i--)
   {
      if (tfs==sTfTable[i] || tfs==""+IntegerToString(iTfTable[i])) 
      {
//         return(MathMax(iTfTable[i],Period()));
         return(iTfTable[i]);
      }
   }
   return(Period());
   
}

string tf2str(int tf)
{
   if(tf==0) tf=Period();
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
   return("");
}  