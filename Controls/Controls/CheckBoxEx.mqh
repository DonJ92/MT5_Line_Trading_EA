//+------------------------------------------------------------------+
//|                                                   CheckBoxEx.mqh |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include <Controls\WndContainer.mqh>
#include <Controls\Edit.mqh>
#include <Controls\BmpButton.mqh>
#include <Controls\ComboBox.mqh>

//+------------------------------------------------------------------+
//| Resources                                                        |
//+------------------------------------------------------------------+
#resource "res\\CheckBoxOn.bmp"
#resource "res\\CheckBoxOff.bmp"
//+------------------------------------------------------------------+
//| Class CCheckBox                                                  |
//| Usage: class that implements the "CheckBox" control              |
//+------------------------------------------------------------------+
class CCheckBoxEx : public CWndContainer
  {
private:
   //--- dependent controls
   CBmpButton        m_button;              // button object
   CEdit             m_label;               // label object
   //--- data
   int               m_value;               // value

public:
                     CCheckBoxEx(void);
                    ~CCheckBoxEx(void);
   //--- create
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2,bool noLabelFlag=false);
   //--- chart event handler
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- settings
   string            Text(void)          const { return(m_label.Text());         }
   bool              Text(const string value)  { return(m_label.Text(value));    }
   color             Color(void)         const { return(m_label.Color());        }
   bool              Color(const color value)  { return(m_label.Color(value));   }
   bool              Font(string value)        { return(m_label.Font(value));    }
   bool              FontSize(int value)       { return(m_label.FontSize(value));}
   //--- state
   bool              Checked(void)       const { return(m_button.Pressed());     }
   bool              Checked(const bool flag)  { return(m_button.Pressed(flag)); }
   //--- data
   int               Value(void)         const { return(m_value);                }
   void              Value(const int value)    { m_value=value;                  }
   //--- methods for working with files
   virtual bool      Save(const int file_handle);
   virtual bool      Load(const int file_handle);

protected:
   //--- create dependent controls
   virtual bool      CreateButton(void);
   virtual bool      CreateLabel(void);
   //--- handlers of the dependent controls events
   virtual bool      OnClickButton(void);
   virtual bool      OnClickLabel(void);
  };
//+------------------------------------------------------------------+
//| Common handler of chart events                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CCheckBoxEx)
   ON_EVENT(ON_CLICK,m_button,OnClickButton)
   //ON_EVENT(ON_CLICK,m_label,OnClickLabel)
EVENT_MAP_END(CWndContainer)
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CCheckBoxEx::CCheckBoxEx(void) : m_value(0)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CCheckBoxEx::~CCheckBoxEx(void)
  {
  }
//+------------------------------------------------------------------+
//| Create a control                                                 |
//+------------------------------------------------------------------+
bool CCheckBoxEx::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2,bool noLabelFlag)
  {
//--- call method of the parent class
   if(!CWndContainer::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
//--- create dependent controls
   if(!CreateButton())
      return(false);
   if(!noLabelFlag)
     {   
      if(!CreateLabel())
         return(false);
     }
//--- succeeded
   return(true);
  }
//+------------------------------------------------------------------+
//| Create button                                                    |
//+------------------------------------------------------------------+
bool CCheckBoxEx::CreateButton(void)
  {
//--- calculate coordinates
   int x1=CONTROLS_CHECK_BUTTON_X_OFF;
   int y1=CONTROLS_CHECK_BUTTON_Y_OFF;
   int x2=x1+CONTROLS_BUTTON_SIZE;
   int y2=y1+CONTROLS_BUTTON_SIZE-CONTROLS_BORDER_WIDTH;
//--- create
   if(!m_button.Create(m_chart_id,m_name+"Button",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_button.BmpNames("::res\\CheckBoxOff.bmp","::res\\CheckBoxOn.bmp"))
      return(false);
   if(!Add(m_button))
      return(false);
   m_button.Locking(true);
//--- succeeded
   return(true);
  }
//+------------------------------------------------------------------+
//| Create label                                                     |
//+------------------------------------------------------------------+
bool CCheckBoxEx::CreateLabel(void)
  {
//--- calculate coordinates
   int x1=CONTROLS_CHECK_LABEL_X_OFF;
   int y1=CONTROLS_CHECK_LABEL_Y_OFF;
   int x2=Width();
   int y2=Height();
//--- create
   if(!m_label.Create(m_chart_id,m_name+"Label",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!m_label.Text(m_name))
      return(false);
   if(!Add(m_label))
      return(false);
   m_label.ReadOnly(true);
   m_label.ColorBackground(CONTROLS_CHECKGROUP_COLOR_BG);
   m_label.ColorBorder(CONTROLS_CHECKGROUP_COLOR_BG);
//--- succeeded
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCheckBoxEx::Save(const int file_handle)
  {
//--- check
   if(file_handle==INVALID_HANDLE)
      return(false);
//---
   FileWriteInteger(file_handle,Checked());
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CCheckBoxEx::Load(const int file_handle)
  {
//--- check
   if(file_handle==INVALID_HANDLE)
      return(false);
//---
   if(!FileIsEnding(file_handle))
      Checked(FileReadInteger(file_handle));
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Handler of click on button                                       |
//+------------------------------------------------------------------+
bool CCheckBoxEx::OnClickButton(void)
  {
//--- send the "changed state" event
   EventChartCustom(CONTROLS_SELF_MESSAGE,ON_CHANGE,m_id,0.0,m_name);
//--- handled
   return(true);
  }
//+------------------------------------------------------------------+
//| Handler of click on label                                        |
//+------------------------------------------------------------------+
bool CCheckBoxEx::OnClickLabel(void)
  {
//--- change button state
   m_button.Pressed(!m_button.Pressed());
//--- return the result of the button click handler
   return(OnClickButton());
  }
//+------------------------------------------------------------------+