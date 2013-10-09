using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InTheHand.Net;

namespace A_Pod_System_Controll
{
    class SendModule
    {
        public static ObexStatusCode SendFile(BluetoothAddress address, string file_path)
        {
            string FileName = file_path.Substring(file_path.LastIndexOf("\\"));
            Uri uri = new Uri("obex://" + address.ToString() + "/" + file_path);

            ObexWebRequest request = new ObexWebRequest(uri);
            request.ReadFile(file_path);
            ObexWebResponse response = (ObexWebResponse)request.GetResponse();
            response.Close();

            return response.StatusCode;
        }
    }
}
