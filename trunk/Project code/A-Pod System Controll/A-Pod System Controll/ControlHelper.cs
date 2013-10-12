﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO.Ports;
using System.IO;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Collections;

namespace A_Pod_System_Controll
{
    class ControlHelper
    {
        public static IEnumerable<T> FindVisualChildren<T>(DependencyObject depObj) where T : DependencyObject
        {
            if (depObj != null)
            {
                for (int i = 0; i < VisualTreeHelper.GetChildrenCount(depObj); i++)
                {
                    DependencyObject child = VisualTreeHelper.GetChild(depObj, i);
                    if (child != null && child is T)
                    {
                        yield return (T)child;
                    }

                    foreach (T childOfChild in FindVisualChildren<T>(child))
                    {
                        yield return childOfChild;
                    }
                }
            }
        }

        public static string[] CheckPort()
        {
            ArrayList listPort = new ArrayList();
            int i = 0;
            foreach (var portname in SerialPort.GetPortNames())
            {
                listPort.Add(portname);
                i++;
            }
            string[] list = new string[i];
            i = 0;
            foreach (var tmp in listPort)
            {
                list[i] = tmp.ToString();
                i++;
            }
            return list;
        }
    }
}
