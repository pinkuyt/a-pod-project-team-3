using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace APOD_Controller.Sequences
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

        public new void Clear()
        {
            base.Clear();
            RemoveList.Clear();
        }
    }
}
