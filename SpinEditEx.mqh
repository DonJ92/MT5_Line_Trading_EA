//+------------------------------------------------------------------+
//|                                                     SpinEdit.mqh |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include <Controls\WndContainer.mqh>
#include <Controls\Edit.mqh>
#include <Controls\BmpButton.mqh>
#include <Controls\Checkbox.mqh>

class CCheckBoxEx : public CCheckBox
  {
protected:
   //--- create dependent controls
   virtual bool      CreateLabel(void) { /*CCheckBox::CreateLabel(); m_label.Hide();*/ return true; }
  };
//+------------------------------------------------------------------+
//| Resources                                                        |
//+------------------------------------------------------------------+
#resource "SpinInc.bmp"
#resource "SpinDec.bmp"
//+------------------------------------------------------------------+
//| Class CSpinEditEx                                                  |
//| Usage: class that implements the "Up-Down" control               |
//+------------------------------------------------------------------+
class CSpinEditEx : public CWndContainer
  {
private:
   //--- dependent controls
   CEdit             m_edit;                // the entry field object
   CBmpButton        m_inc;                 // the "Increment button" object
   CBmpButton        m_dec;                 // the "Decrement button" object
   CCheckBoxEx       m_chkbox;
   //--- adjusted parameters
   double            m_min_value;           // minimum value
   double            m_max_value;           // maximum value
   //--- state
   double            m_value;               // current value
   double            m_value_step;
   int               m_value_digits;
   
   bool              m_checked;
   string            m_suffix;
public:
                     CSpinEditEx(void);
                    ~CSpinEditEx(void);
   //--- create
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2, bool checkable = false);
   //--- chart event handler
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- set up
   double            MinValue(void) const { return(m_min_value); }
   void              MinValue(const double value);
   double            MaxValue(void) const { return(m_max_value); }
   void              MaxValue(const double value);
   //--- state
   double            Value(void) const { return(m_value); }
   bool              Value(double value);
   double            ValueStep(void) const { return(m_value_step); }
   bool              ValueStep(double value_step);
   int               ValueDigits(void) const { return(m_value_digits); }
   bool              ValueDigits(int m_value_digits);
   //--- state
   CCheckBoxEx*      Checkbox(void) const { return((CCheckBoxEx*)GetPointer(m_chkbox)); }   
   bool              Checked(void) const { return(m_checked); }
   bool              Checked(bool checked);
   //--- suffix
   string            Suffix(void) const { return(m_suffix); }
   bool              Suffix(string suffix);
   //--- methods for working with files
   virtual bool      Save(const int file_handle);
   virtual bool      Load(const int file_handle);

protected:
   //--- create dependent controls
   virtual bool      CreateEdit(void);
   virtual bool      CreateInc(void);
   virtual bool      CreateDec(void);
   virtual bool      CreateCheckbox(void);
   //--- handlers of the dependent controls events
   virtual bool      OnClickInc(void);
   virtual bool      OnClickDec(void);
   //--- internal event handlers
   virtual bool      OnChangeValue(void);
   virtual bool      OnChangeChecked(void);
  };
//+------------------------------------------------------------------+
//| Common handler of chart events                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CSpinEditEx)
   ON_EVENT(ON_CLICK,m_inc,OnClickInc)
   ON_EVENT(ON_CLICK,m_dec,OnClickDec)
   ON_EVENT(ON_CHANGE,m_chkbox,OnChangeChecked)
EVENT_MAP_END(CWndContainer)
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSpinEditEx::CSpinEditEx(void) : m_min_value(-99999999),
                             m_max_value(99999999),
                             m_value(-99999999),
                             m_value_digits(1),
                             m_checked(false)
  {
   m_value_step=MathPow(10,-m_value_digits);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSpinEditEx::~CSpinEditEx(void)
  {
  }
//+------------------------------------------------------------------+
//| Create a control                                                 |
//+------------------------------------------------------------------+
bool CSpinEditEx::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2, bool checkable)
  {
//--- check height
   if(y2-y1<CONTROLS_SPIN_MIN_HEIGHT)
      return(false);
//--- call method of the parent class
   if(!CWndContainer::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
//--- create dependent controls
   if(!CreateEdit())
      return(false);
   if(!CreateInc())
      return(false);
   if(!CreateDec())
      return(false);
   if (checkable)
     {
      if(!CreateCheckbox())
         return(false);
     }
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Set current value                                                |
//+------------------------------------------------------------------+
bool CSpinEditEx::Value(double value)
  {
//--- if value was changed
   if(m_value!=value)
     {
      //--- check value
      if(value<m_min_value)
         value=m_min_value;
      if(value>m_max_value)
         value=m_max_value;
         
      m_value=value;
      //--- call virtual handler
      return(OnChangeValue());
     }
//--- value has not been changed
   return(false);
  }
//+------------------------------------------------------------------+
//| Set current value                                                |
//+------------------------------------------------------------------+
bool CSpinEditEx::ValueStep(double value_step)
  {
//--- if value was changed
   if(m_value_step!=value_step)
     {
      m_value_step=value_step;
      //--- call virtual handler
      return(true);
     }
//--- value has not been changed
   return(false);
  }  
//+------------------------------------------------------------------+
//| Set checked value                                                |
//+------------------------------------------------------------------+
bool CSpinEditEx::Checked(bool checked)
  {
//--- if value was changed
   //if(m_checked!=checked)
     {
      m_checked=checked;
      //--- call virtual handler
      return(OnChangeValue());
     }
//--- value has not been changed
   return(false);
  }
//+------------------------------------------------------------------+
//| Set suffix value                                                |
//+------------------------------------------------------------------+  
bool CSpinEditEx::Suffix(string suffix)
  {
   if(m_suffix!=suffix)
     {
      m_suffix=suffix;
      //--- call virtual handler
      return(OnChangeValue());
     }
   //--- value has not been changed
   return(false);  
  }  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSpinEditEx::Save(const int file_handle)
  {
//--- check
   if(file_handle==INVALID_HANDLE)
      return(false);
//---
   FileWriteDouble(file_handle,m_value);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSpinEditEx::Load(const int file_handle)
  {
//--- check
   if(file_handle==INVALID_HANDLE)
      return(false);
//---
   if(!FileIsEnding(file_handle))
      Value(FileReadInteger(file_handle));
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Set minimum value                                                |
//+------------------------------------------------------------------+
void CSpinEditEx::MinValue(const double value)
  {
//--- if value was changed
   if(m_min_value!=value)
     {
      m_min_value=value;
      //--- adjust the edit value
      Value(m_value);
     }
  }
//+------------------------------------------------------------------+
//| Set maximum value                                                |
//+------------------------------------------------------------------+
void CSpinEditEx::MaxValue(const double value)
  {
//--- if value was changed
   if(m_max_value!=value)
     {
      m_max_value=value;
      //--- adjust the edit value
      Value(m_value);
     }
  }
//+------------------------------------------------------------------+
//| Create the edit field                                            |
//+------------------------------------------------------------------+
bool CSpinEditEx::CreateEdit(void)
  {
//--- create
   if(!m_edit.Create(m_chart_id,m_name+"Edit",m_subwin,0,0,Width(),Height()))
      return(false);
   if(!m_edit.Text(""))
      return(false);
   if(!m_edit.ReadOnly(true))
      return(false);
   if(!m_edit.TextAlign(ALIGN_RIGHT))
      return(false);
   if(!m_edit.Text(DoubleToString(m_value,m_value_digits) + " " + m_suffix))
      return(false);
      
   if(!Add(m_edit))
      return(false);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Increment" button                                    |
//+------------------------------------------------------------------+
bool CSpinEditEx::CreateInc(void)
  {
//--- right align button (try to make equal offsets from top and bottom)
   int x1=Width()-(CONTROLS_BUTTON_SIZE+CONTROLS_SPIN_BUTTON_X_OFF);
   int y1=(Height()-2*CONTROLS_SPIN_BUTTON_SIZE)/2;
   int x2=x1+CONTROLS_BUTTON_SIZE;
   int y2=y1+CONTROLS_SPIN_BUTTON_SIZE;
//--- create
   if(!m_inc.Create(m_chart_id,m_name+"Inc",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_inc.BmpNames("::SpinInc.bmp"))
      return(false);
   if(!Add(m_inc))
      return(false);
//--- property
   m_inc.PropFlags(WND_PROP_FLAG_CLICKS_BY_PRESS);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the "Decrement" button                                    |
//+------------------------------------------------------------------+
bool CSpinEditEx::CreateDec(void)
  {
//--- right align button (try to make equal offsets from top and bottom)
   int x1=Width()-(CONTROLS_BUTTON_SIZE+CONTROLS_SPIN_BUTTON_X_OFF);
   int y1=(Height()-2*CONTROLS_SPIN_BUTTON_SIZE)/2+CONTROLS_SPIN_BUTTON_SIZE;
   int x2=x1+CONTROLS_BUTTON_SIZE;
   int y2=y1+CONTROLS_SPIN_BUTTON_SIZE;
//--- create
   if(!m_dec.Create(m_chart_id,m_name+"Dec",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_dec.BmpNames("::SpinDec.bmp"))
      return(false);
   if(!Add(m_dec))
      return(false);
//--- property
   m_dec.PropFlags(WND_PROP_FLAG_CLICKS_BY_PRESS);
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Create the edit field                                            |
//+------------------------------------------------------------------+
bool CSpinEditEx::CreateCheckbox(void)
  {
//--- create
   if(!m_chkbox.Create(m_chart_id,m_name+"Checkbox",m_subwin,0,0,20,20))
      return(false);
   if(!Add(m_chkbox))
      return(false);
//--- succeed
   return(true);
  }  
//+------------------------------------------------------------------+
//| Handler of click on the "increment" button                       |
//+------------------------------------------------------------------+
bool CSpinEditEx::OnClickInc(void)
  {
//--- try to increment current value
   return(Value(m_value+m_value_step));
  }
//+------------------------------------------------------------------+
//| Handler of click on the "decrement" button                       |
//+------------------------------------------------------------------+
bool CSpinEditEx::OnClickDec(void)
  {
//--- try to decrement current value
   return(Value(m_value-m_value_step));
  }
//+------------------------------------------------------------------+
//| Handler of changing current state                                |
//+------------------------------------------------------------------+
bool CSpinEditEx::OnChangeValue(void)
  {
//--- copy text to the edit field edit
   m_edit.Text(DoubleToString(m_value,m_value_digits) + " " + m_suffix);
   m_chkbox.Checked(m_checked);
//--- send notification
   EventChartCustom(CONTROLS_SELF_MESSAGE,ON_CHANGE,m_id,0.0,m_name);
//--- handled
   return(true);
  }
//+------------------------------------------------------------------+
//| Handler of changing current check state                                |
//+------------------------------------------------------------------+
bool CSpinEditEx::OnChangeChecked(void)
  {
   return Checked(m_chkbox.Checked());
  }  
//+------------------------------------------------------------------+
