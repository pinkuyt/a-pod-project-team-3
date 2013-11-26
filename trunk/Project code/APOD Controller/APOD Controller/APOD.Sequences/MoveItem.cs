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
        public static readonly List<string> AvailableMoves = new List<string>(new[]
        {
            "Forward",
            "Backward",
            "Turn Left",
            "Turn Right",
            "Body Lift",
            "Body Drop",
            "Toward Front",
            "Toward Back",
            "Squeeze Left",
            "Squeeze Right",
            "Head Up",
            "Head Down",
            "Head Left",
            "Head Right",
            "Head Roll Left",
            "Head Roll Right"
        });

        public const string Forward = "Forward";
        public const string Backward = "Backward";
        public const string TurnLeft = "Turn Left";
        public const string TurnRight = "Turn Right";
        public const string BodyLift = "Body Lift";
        public const string BodyDrop = "Body Drop";
        public const string TowardFront = "Toward Front";
        public const string TowardBack = "Toward Back";
        public const string SqueezeLeft = "Squeeze Left";
        public const string SqueezeRight = "Squeeze Right";
        public const string HeadUp = "Head Up";
        public const string HeadDown = "Head Down";
        public const string HeadLeft = "Head Left";
        public const string HeadRight = "Head Right";
        public const string HeadRollLeft = "Head Roll Left";
        public const string HeadRollRight = "Head Roll Right";

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
        /// Will this move change APOD Position 
        /// </summary>
        /// <param name="name">move's name</param>
        /// <returns></returns>
        public static bool IsPositionMove(string name)
        {
            return (name.Equals(Forward) || name.Equals(Backward) || name.Equals(TurnLeft) || name.Equals(TurnRight));
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
