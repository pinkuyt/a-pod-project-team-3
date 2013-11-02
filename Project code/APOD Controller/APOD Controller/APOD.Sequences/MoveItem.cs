using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace APOD_Controller.APOD.Sequences
{
    /// <summary>
    /// Contain information of one move of the APOD
    /// </summary>
    public class MoveItem : IEquatable<MoveItem>
    {
        // move identity
        public int ID { get; set; }
        // name of move
        public string Name { get; set; }
        // moving distance/degree
        public int Interval { get; set; }

        /// <summary>
        /// Constructor with id, used to create equal instance
        /// </summary>
        /// <param name="id"></param>
        public MoveItem(int id)
        {
            ID = id;
            Interval = 0;
            Name = "";
        }

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="id">Id</param>
        /// <param name="name">Move's name</param>
        /// <param name="interval">Moving distance/degree</param>
        public MoveItem(int id, string name, int interval)
        {
            ID = id;
            Interval = interval;
            Name = name;
        }

        /// <summary>
        /// Implementation of IEquatable interface
        /// </summary>
        /// <param name="other">Compare object</param>
        /// <returns>True if equal, else return False</returns>
        public bool Equals(MoveItem other)
        {
            //return (Name.Equals(other.Name) && (Interval == other.Interval));
            return ID == other.ID;
        }
    }
}
