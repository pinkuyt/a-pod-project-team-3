using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace A_Pod_System_Controll
{
    class ControlConstant
    {
        /*
         * Common Controls
         */
        public const string TURN_APOD_ON_OFF = "0";
        public const string OPEN_MANDIBLEs = "1";
        public const string CLOSE_MANDIBLES = "2";
        public const string DECREASE_GRIPPER_TORGUE = "3";
        public const string INCREASE_GRIPPER_TORGUE = "4";
        public const string TORGUE_ROTATION_MODE = "5";
        public const string TORGUE_SHIFT_MODE = "6";
        public const string TORGUE_BALANCE_MODE = "7";
        public const string SWITCH_BODY_DEFAULT_LOW = "8";
        public const string BODY_UP = "9";
        public const string BODY_DOWN = "10";
        public const string DECREASE_SPEED = "11";
        public const string INCREASE_SPEED = "12";

        /*
         * Walk Mode Controls (DEFAULT MODE 1)
         */
        public const string CHANGE_GAITS = "13";
        public const string WALK_MODE_1_FORWARD = "14";
        public const string WALK_MODE_1_BACKWARD = "15";
        public const string WALK_MODE_1_TURN_LEFT = "16";
        public const string WALK_MODE_1_TURN_RIGHT = "17";
        public const string TOGGLE_DOUBLE_GAIT_TRAVEL_HEIGHT = "18";
        public const string TOGGLE_DOUBLE_GAIT_TRAVEL_LENGHT = "19";
        /*
         * Shift Mode Controls
         */
        public const string TURN_SHIFT_MODE_OFF = "20";
        public const string SHIFT_BODY_X_Z_LEFT = "21";
        public const string SHIFT_BODY_X_Z_RIGHT = "22";
        public const string SHIFT_BODY_Y_FORWARD = "23";
        public const string SHIFT_BODY_Y_BACKWARD = "24";
        /*
         * Rotate Mode Controls
         */
        public const string TURN_ROTATE_MODE_OFF = "25";
        public const string ROTATE_X_TRANSLATE_Z_LEFT = "26";
        public const string ROTATE_X_TRANSLATE_Z_RIGHT = "27";
        public const string CYCLE_ROTATE_FUNCTION = "28"; // Cycle rotate function (Head tracking, fixed head, head only)
        public const string MOVE_CENTER_OF_ROTATION_TO_HEAD = "29";//(when held)
        public const string MOVE_CENTER_OF_ROTATION_TO_TAIL = "30";//(when held)
        public const string RESET_BODY_ROTATION = "31";
    }
}
