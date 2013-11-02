using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace APOD_Controller.APOD.Sequences
{
    public class MoveItemsCollection : List<MoveItem>
    {
        /// <summary>
        /// List contain all states to be remove of a sequence
        /// </summary>
        public List<int> RemoveList { get; set; }

        /// <summary>
        /// Default constructor
        /// </summary>
        public MoveItemsCollection()
        {
            RemoveList = new List<int>();
        }

        /// <summary>
        /// Mark item to be removed
        /// </summary>
        /// <param name="id">MoveItem's ID</param>
        public void MarkRemove(int id)
        {
            RemoveList.Add(id);
        }

        /// <summary>
        /// Unmark item to be removed
        /// </summary>
        /// <param name="id">MoveItem's ID</param>
        public void UnmarkRemove(int id)
        {
            RemoveList.Remove(id);
        }

        /// <summary>
        /// Remove an item with ID
        /// </summary>
        /// <param name="id">MoveItem's ID</param>
        private void Remove(int id)
        {
            Remove(new MoveItem(id));
        }

        /// <summary>
        /// Execute removal of state that is marked as delete
        /// </summary>
        public void Remove()
        {
            // remove all mark items
            for (int i = 0; i < RemoveList.Count; i++)
            {
                Remove(RemoveList[i]);
            }
            // clear marked list
            RemoveList.Clear();

            // renew ID
            for (int i = 0; i < Count; i++)
            {
                this[i].ID = i;
            }
        }

        /// <summary>
        /// Reset sequence
        /// </summary>
        public new void Clear()
        {
            base.Clear();
            RemoveList.Clear();
        }

        /// <summary>
        /// Export current sequence to XML
        /// </summary>
        /// <returns>XMLDocument instane contain states of sequence</returns>
        public XmlDocument Export()
        {
            /*----------------- Create XML document -----------------*/
            var doc = new XmlDocument();
            //root
            XmlNode root = doc.CreateElement("Moves");
            doc.AppendChild(root);

            foreach (MoveItem item in this)
            {
                // single move tag
                XmlNode move = doc.CreateElement("Move");
                // Name property
                XmlAttribute attribute = doc.CreateAttribute("Name");
                attribute.Value = item.Name;
                if (move.Attributes != null) move.Attributes.Append(attribute);
                else return null;
                // Interval property
                attribute = doc.CreateAttribute("Interval");
                attribute.Value = item.Interval.ToString();
                move.Attributes.Append(attribute);

                root.AppendChild(move);
            }
            return doc;
        }

        /// <summary>
        /// Import states of existed sequence
        /// </summary>
        /// <param name="filename">File path</param>
        /// <returns>Collection of states</returns>
        public static MoveItemsCollection Import(string filename)
        {
            MoveItemsCollection states = new MoveItemsCollection();
            XmlDocument doc = new XmlDocument();
            doc.Load(filename);

            XmlNodeList moves = doc.GetElementsByTagName("Move");
            int count = 0;
            int value = 0;
            bool incorrupted;

            foreach (XmlNode move in moves)
            {
                // check data integrity
                incorrupted = (move.Attributes != null) && (int.TryParse(move.Attributes["Interval"].Value, out value));
                // if damaged return null
                if (!incorrupted) return null;
                // else keep processing
                states.Add(new MoveItem(count, move.Attributes["Name"].Value,
                                        value));
                count++;
            }
            return states;
        }

    }
}
