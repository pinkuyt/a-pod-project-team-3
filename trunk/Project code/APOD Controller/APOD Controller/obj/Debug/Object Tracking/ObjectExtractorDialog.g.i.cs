﻿#pragma checksum "..\..\..\Object Tracking\ObjectExtractorDialog.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "9D27335D340EDD0C2FB6FD1A043D5C2D"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.34003
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

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


namespace APOD_Controller.Object_Tracking {
    
    
    /// <summary>
    /// ObjectExtractorDialog
    /// </summary>
    public partial class ObjectExtractorDialog : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
        #line 15 "..\..\..\Object Tracking\ObjectExtractorDialog.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Forms.Panel pnlCapture;
        
        #line default
        #line hidden
        
        
        #line 26 "..\..\..\Object Tracking\ObjectExtractorDialog.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button btnOK;
        
        #line default
        #line hidden
        
        
        #line 27 "..\..\..\Object Tracking\ObjectExtractorDialog.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button btnESC;
        
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
            System.Uri resourceLocater = new System.Uri("/APOD Controller;component/object%20tracking/objectextractordialog.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\..\Object Tracking\ObjectExtractorDialog.xaml"
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
            this.pnlCapture = ((System.Windows.Forms.Panel)(target));
            
            #line 15 "..\..\..\Object Tracking\ObjectExtractorDialog.xaml"
            this.pnlCapture.MouseDown += new System.Windows.Forms.MouseEventHandler(this.pnlCapture_MouseDown);
            
            #line default
            #line hidden
            
            #line 15 "..\..\..\Object Tracking\ObjectExtractorDialog.xaml"
            this.pnlCapture.MouseMove += new System.Windows.Forms.MouseEventHandler(this.pnlCapture_MouseMove);
            
            #line default
            #line hidden
            
            #line 15 "..\..\..\Object Tracking\ObjectExtractorDialog.xaml"
            this.pnlCapture.MouseUp += new System.Windows.Forms.MouseEventHandler(this.pnlCapture_MouseUp);
            
            #line default
            #line hidden
            
            #line 15 "..\..\..\Object Tracking\ObjectExtractorDialog.xaml"
            this.pnlCapture.Paint += new System.Windows.Forms.PaintEventHandler(this.pnlCapture_Paint);
            
            #line default
            #line hidden
            return;
            case 2:
            this.btnOK = ((System.Windows.Controls.Button)(target));
            
            #line 26 "..\..\..\Object Tracking\ObjectExtractorDialog.xaml"
            this.btnOK.Click += new System.Windows.RoutedEventHandler(this.btnOK_Click);
            
            #line default
            #line hidden
            return;
            case 3:
            this.btnESC = ((System.Windows.Controls.Button)(target));
            
            #line 27 "..\..\..\Object Tracking\ObjectExtractorDialog.xaml"
            this.btnESC.Click += new System.Windows.RoutedEventHandler(this.btnESC_Click);
            
            #line default
            #line hidden
            return;
            }
            this._contentLoaded = true;
        }
    }
}

