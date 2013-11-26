﻿#pragma checksum "..\..\MainWindow.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "21D40157476FB4A8B15A37EB5E82A294"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.34003
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using AForge.Controls;
using APOD_Controller;
using APOD_Controller.APOD.Sequences;
using APOD_Keypad;
using MahApps.Metro.Controls;
using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Forms;
using System.Windows.Forms.Integration;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Media.TextFormatting;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Shell;


namespace APOD_Controller {
    
    
    /// <summary>
    /// MainWindow
    /// </summary>
    public partial class MainWindow : MahApps.Metro.Controls.MetroWindow, System.Windows.Markup.IComponentConnector, System.Windows.Markup.IStyleConnector {
        
        
        #line 18 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.MenuItem menuLive;
        
        #line default
        #line hidden
        
        
        #line 19 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.MenuItem menuPlayer;
        
        #line default
        #line hidden
        
        
        #line 20 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.MenuItem menuConfig;
        
        #line default
        #line hidden
        
        
        #line 36 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TabControl tabControl;
        
        #line default
        #line hidden
        
        
        #line 38 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TabItem tabLiveControl;
        
        #line default
        #line hidden
        
        
        #line 40 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Grid gridLive;
        
        #line default
        #line hidden
        
        
        #line 51 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Border pnlNavigation;
        
        #line default
        #line hidden
        
        
        #line 72 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key navLeft;
        
        #line default
        #line hidden
        
        
        #line 74 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key navRight;
        
        #line default
        #line hidden
        
        
        #line 76 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key navUp;
        
        #line default
        #line hidden
        
        
        #line 78 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key navDown;
        
        #line default
        #line hidden
        
        
        #line 84 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Border pnlAction;
        
        #line default
        #line hidden
        
        
        #line 105 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key actSquare;
        
        #line default
        #line hidden
        
        
        #line 107 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key actCircle;
        
        #line default
        #line hidden
        
        
        #line 109 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key actTriangle;
        
        #line default
        #line hidden
        
        
        #line 111 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key actCross;
        
        #line default
        #line hidden
        
        
        #line 116 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Border pnlTriggers;
        
        #line default
        #line hidden
        
        
        #line 120 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key actL1;
        
        #line default
        #line hidden
        
        
        #line 122 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key actL2;
        
        #line default
        #line hidden
        
        
        #line 124 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key actR1;
        
        #line default
        #line hidden
        
        
        #line 126 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key actR2;
        
        #line default
        #line hidden
        
        
        #line 130 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Border pnlFunction;
        
        #line default
        #line hidden
        
        
        #line 134 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key actStart;
        
        #line default
        #line hidden
        
        
        #line 135 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal APOD_Keypad.Key actSelect;
        
        #line default
        #line hidden
        
        
        #line 142 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Image imgSplash;
        
        #line default
        #line hidden
        
        
        #line 145 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Forms.Integration.WindowsFormsHost hostCam;
        
        #line default
        #line hidden
        
        
        #line 148 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal AForge.Controls.VideoSourcePlayer viewCam;
        
        #line default
        #line hidden
        
        
        #line 153 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.RadioButton rdModeNormal;
        
        #line default
        #line hidden
        
        
        #line 156 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.RadioButton rdModeKeypad;
        
        #line default
        #line hidden
        
        
        #line 159 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.RadioButton rdModeObjTracking;
        
        #line default
        #line hidden
        
        
        #line 162 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button btnStream;
        
        #line default
        #line hidden
        
        
        #line 164 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Expander pnlTrackingObject;
        
        #line default
        #line hidden
        
        
        #line 167 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ComboBox cbTrackingMethod;
        
        #line default
        #line hidden
        
        
        #line 171 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Image imgTrackingColor;
        
        #line default
        #line hidden
        
        
        #line 172 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Image imgTrackingGlyph;
        
        #line default
        #line hidden
        
        
        #line 173 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button btnTrackingChangeTarget;
        
        #line default
        #line hidden
        
        
        #line 174 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.CheckBox btnTrackingLock;
        
        #line default
        #line hidden
        
        
        #line 184 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TabItem tabPlayer;
        
        #line default
        #line hidden
        
        
        #line 199 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ComboBox cbDirection;
        
        #line default
        #line hidden
        
        
        #line 204 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox txtInterval;
        
        #line default
        #line hidden
        
        
        #line 206 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button btnSequenceAdd;
        
        #line default
        #line hidden
        
        
        #line 216 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.DataGrid tblSequences;
        
        #line default
        #line hidden
        
        
        #line 237 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button btnImport;
        
        #line default
        #line hidden
        
        
        #line 238 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button btnExport;
        
        #line default
        #line hidden
        
        
        #line 242 "..\..\MainWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button btnPlay;
        
        #line default
        #line hidden
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri("/APOD Controller;component/mainwindow.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\MainWindow.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
            #line default
            #line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")]
        void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 1:
            
            #line 12 "..\..\MainWindow.xaml"
            ((APOD_Controller.MainWindow)(target)).Closing += new System.ComponentModel.CancelEventHandler(this.MetroWindow_Closing);
            
            #line default
            #line hidden
            return;
            case 2:
            this.menuLive = ((System.Windows.Controls.MenuItem)(target));
            
            #line 18 "..\..\MainWindow.xaml"
            this.menuLive.Click += new System.Windows.RoutedEventHandler(this.menuLive_Click);
            
            #line default
            #line hidden
            return;
            case 3:
            this.menuPlayer = ((System.Windows.Controls.MenuItem)(target));
            
            #line 19 "..\..\MainWindow.xaml"
            this.menuPlayer.Click += new System.Windows.RoutedEventHandler(this.menuPlayer_Click);
            
            #line default
            #line hidden
            return;
            case 4:
            this.menuConfig = ((System.Windows.Controls.MenuItem)(target));
            
            #line 20 "..\..\MainWindow.xaml"
            this.menuConfig.Click += new System.Windows.RoutedEventHandler(this.menuConfig_Click);
            
            #line default
            #line hidden
            return;
            case 5:
            this.tabControl = ((System.Windows.Controls.TabControl)(target));
            return;
            case 6:
            this.tabLiveControl = ((System.Windows.Controls.TabItem)(target));
            return;
            case 7:
            this.gridLive = ((System.Windows.Controls.Grid)(target));
            return;
            case 8:
            this.pnlNavigation = ((System.Windows.Controls.Border)(target));
            return;
            case 9:
            this.navLeft = ((APOD_Keypad.Key)(target));
            return;
            case 10:
            this.navRight = ((APOD_Keypad.Key)(target));
            return;
            case 11:
            this.navUp = ((APOD_Keypad.Key)(target));
            return;
            case 12:
            this.navDown = ((APOD_Keypad.Key)(target));
            return;
            case 13:
            this.pnlAction = ((System.Windows.Controls.Border)(target));
            return;
            case 14:
            this.actSquare = ((APOD_Keypad.Key)(target));
            return;
            case 15:
            this.actCircle = ((APOD_Keypad.Key)(target));
            return;
            case 16:
            this.actTriangle = ((APOD_Keypad.Key)(target));
            return;
            case 17:
            this.actCross = ((APOD_Keypad.Key)(target));
            return;
            case 18:
            this.pnlTriggers = ((System.Windows.Controls.Border)(target));
            return;
            case 19:
            this.actL1 = ((APOD_Keypad.Key)(target));
            return;
            case 20:
            this.actL2 = ((APOD_Keypad.Key)(target));
            return;
            case 21:
            this.actR1 = ((APOD_Keypad.Key)(target));
            return;
            case 22:
            this.actR2 = ((APOD_Keypad.Key)(target));
            return;
            case 23:
            this.pnlFunction = ((System.Windows.Controls.Border)(target));
            return;
            case 24:
            this.actStart = ((APOD_Keypad.Key)(target));
            return;
            case 25:
            this.actSelect = ((APOD_Keypad.Key)(target));
            return;
            case 26:
            
            #line 138 "..\..\MainWindow.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.Button_Click_1);
            
            #line default
            #line hidden
            return;
            case 27:
            
            #line 139 "..\..\MainWindow.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.Button_Click_2);
            
            #line default
            #line hidden
            return;
            case 28:
            this.imgSplash = ((System.Windows.Controls.Image)(target));
            return;
            case 29:
            this.hostCam = ((System.Windows.Forms.Integration.WindowsFormsHost)(target));
            return;
            case 30:
            this.viewCam = ((AForge.Controls.VideoSourcePlayer)(target));
            return;
            case 31:
            this.rdModeNormal = ((System.Windows.Controls.RadioButton)(target));
            
            #line 155 "..\..\MainWindow.xaml"
            this.rdModeNormal.Checked += new System.Windows.RoutedEventHandler(this.rdModeNormal_Checked);
            
            #line default
            #line hidden
            
            #line 155 "..\..\MainWindow.xaml"
            this.rdModeNormal.Unchecked += new System.Windows.RoutedEventHandler(this.rdModeNormal_Unchecked);
            
            #line default
            #line hidden
            return;
            case 32:
            this.rdModeKeypad = ((System.Windows.Controls.RadioButton)(target));
            
            #line 158 "..\..\MainWindow.xaml"
            this.rdModeKeypad.Checked += new System.Windows.RoutedEventHandler(this.rdModeKeypad_Checked);
            
            #line default
            #line hidden
            
            #line 158 "..\..\MainWindow.xaml"
            this.rdModeKeypad.Unchecked += new System.Windows.RoutedEventHandler(this.rdModeKeypad_Unchecked);
            
            #line default
            #line hidden
            return;
            case 33:
            this.rdModeObjTracking = ((System.Windows.Controls.RadioButton)(target));
            
            #line 161 "..\..\MainWindow.xaml"
            this.rdModeObjTracking.Checked += new System.Windows.RoutedEventHandler(this.rdModeObjTracking_Checked);
            
            #line default
            #line hidden
            
            #line 161 "..\..\MainWindow.xaml"
            this.rdModeObjTracking.Unchecked += new System.Windows.RoutedEventHandler(this.rdModeObjTracking_Unchecked);
            
            #line default
            #line hidden
            return;
            case 34:
            this.btnStream = ((System.Windows.Controls.Button)(target));
            
            #line 162 "..\..\MainWindow.xaml"
            this.btnStream.Click += new System.Windows.RoutedEventHandler(this.Streaming_Trigger);
            
            #line default
            #line hidden
            return;
            case 35:
            this.pnlTrackingObject = ((System.Windows.Controls.Expander)(target));
            return;
            case 36:
            this.cbTrackingMethod = ((System.Windows.Controls.ComboBox)(target));
            
            #line 167 "..\..\MainWindow.xaml"
            this.cbTrackingMethod.SelectionChanged += new System.Windows.Controls.SelectionChangedEventHandler(this.cbTrackingMethod_SelectionChanged);
            
            #line default
            #line hidden
            return;
            case 37:
            this.imgTrackingColor = ((System.Windows.Controls.Image)(target));
            return;
            case 38:
            this.imgTrackingGlyph = ((System.Windows.Controls.Image)(target));
            return;
            case 39:
            this.btnTrackingChangeTarget = ((System.Windows.Controls.Button)(target));
            
            #line 173 "..\..\MainWindow.xaml"
            this.btnTrackingChangeTarget.Click += new System.Windows.RoutedEventHandler(this.btnTrackingChangeTarget_Click);
            
            #line default
            #line hidden
            return;
            case 40:
            this.btnTrackingLock = ((System.Windows.Controls.CheckBox)(target));
            
            #line 175 "..\..\MainWindow.xaml"
            this.btnTrackingLock.Checked += new System.Windows.RoutedEventHandler(this.btnTrackingLock_Checked);
            
            #line default
            #line hidden
            
            #line 175 "..\..\MainWindow.xaml"
            this.btnTrackingLock.Unchecked += new System.Windows.RoutedEventHandler(this.btnTrackingLock_Unchecked);
            
            #line default
            #line hidden
            return;
            case 41:
            this.tabPlayer = ((System.Windows.Controls.TabItem)(target));
            return;
            case 42:
            this.cbDirection = ((System.Windows.Controls.ComboBox)(target));
            
            #line 199 "..\..\MainWindow.xaml"
            this.cbDirection.SelectionChanged += new System.Windows.Controls.SelectionChangedEventHandler(this.cbDirection_SelectionChanged);
            
            #line default
            #line hidden
            return;
            case 43:
            this.txtInterval = ((System.Windows.Controls.TextBox)(target));
            
            #line 205 "..\..\MainWindow.xaml"
            this.txtInterval.PreviewTextInput += new System.Windows.Input.TextCompositionEventHandler(this.txtInterval_PreviewTextInput);
            
            #line default
            #line hidden
            return;
            case 44:
            this.btnSequenceAdd = ((System.Windows.Controls.Button)(target));
            
            #line 206 "..\..\MainWindow.xaml"
            this.btnSequenceAdd.Click += new System.Windows.RoutedEventHandler(this.btnSequenceAdd_Click);
            
            #line default
            #line hidden
            return;
            case 45:
            this.tblSequences = ((System.Windows.Controls.DataGrid)(target));
            return;
            case 47:
            
            #line 232 "..\..\MainWindow.xaml"
            ((System.Windows.Controls.Button)(target)).Click += new System.Windows.RoutedEventHandler(this.StateRemove_Click);
            
            #line default
            #line hidden
            return;
            case 48:
            this.btnImport = ((System.Windows.Controls.Button)(target));
            
            #line 237 "..\..\MainWindow.xaml"
            this.btnImport.Click += new System.Windows.RoutedEventHandler(this.btnImport_Click);
            
            #line default
            #line hidden
            return;
            case 49:
            this.btnExport = ((System.Windows.Controls.Button)(target));
            
            #line 238 "..\..\MainWindow.xaml"
            this.btnExport.Click += new System.Windows.RoutedEventHandler(this.btnExport_Click);
            
            #line default
            #line hidden
            return;
            case 50:
            this.btnPlay = ((System.Windows.Controls.Button)(target));
            
            #line 242 "..\..\MainWindow.xaml"
            this.btnPlay.Click += new System.Windows.RoutedEventHandler(this.btnPlay_Click);
            
            #line default
            #line hidden
            return;
            }
            this._contentLoaded = true;
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        void System.Windows.Markup.IStyleConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 46:
            
            #line 222 "..\..\MainWindow.xaml"
            ((System.Windows.Controls.CheckBox)(target)).Checked += new System.Windows.RoutedEventHandler(this.CheckBox_Checked);
            
            #line default
            #line hidden
            
            #line 223 "..\..\MainWindow.xaml"
            ((System.Windows.Controls.CheckBox)(target)).Unchecked += new System.Windows.RoutedEventHandler(this.CheckBox_Unchecked);
            
            #line default
            #line hidden
            break;
            }
        }
    }
}

