using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;

namespace Hexapod
{
    public class APod
    {
        private readonly byte[] START_UP = {(byte) 'S', 1};
        private readonly byte[] SHUT_DOWN = { (byte)'S', 0 };
        /*
         *  Virtualize Physical Component
         */
        #region Entities

        /// <summary>
        /// Head Entity
        /// </summary>
        private Head head; 
        
        /// <summary>
        /// Tail Entity
        /// </summary>
        private Tail tail;

        /// <summary>
        /// Legs Entities
        /// </summary>
        public Leg LeftFront;
        public Leg LeftCenter;
        public Leg LeftRear;
        public Leg RightFront;
        public Leg RightCenter;
        public Leg RightRear;

        /// <summary>
        /// RS232 Communiccation port
        /// </summary>
        private Connector Port; 

        #endregion

        /*
         *  Tripod control command
         */

        /// <summary>
        /// Default constructor
        /// </summary>
        public APod()
        {
            // set up 
            Port = new Connector("COM6", 115100);
            Port.Open();

            // head
            head = new Head(new Servo(14, 1500), new Servo(13, 1500), new Servo(29, 1500),
                            new Servo(12, 1500), new Servo(28, 1500));

            // legs
            LeftFront = new Leg(new Servo(16, 1500), new Servo(17, 1500),
                                new Servo(18, 1500), Leg.LEFT);
            LeftCenter = new Leg(new Servo(20, 1500), new Servo(21, 1500),
                                new Servo(22, 1500), Leg.LEFT);
            LeftRear = new Leg(new Servo(24, 1500), new Servo(25, 1500),
                                new Servo(26, 1500), Leg.LEFT);

            RightFront = new Leg(new Servo(0, 1500), new Servo(1, 1500),
                                new Servo(2, 1500), Leg.RIGHT);
            RightCenter = new Leg(new Servo(4, 1500), new Servo(5, 1500),
                                new Servo(6, 1500), Leg.RIGHT);
            RightRear = new Leg(new Servo(8, 1500), new Servo(9, 1500),
                                new Servo(10, 1500), Leg.RIGHT);
        }

        /// <summary>
        /// Constructor with pre-configured serial port
        /// </summary>
        /// <param name="port">serial port</param>
        public APod(SerialPort port)
        {
            // set up 
            Port = new Connector(port);

            // head
            head = new Head(new Servo(14, 1500), new Servo(13, 1500), new Servo(29, 1500),
                            new Servo(12, 1500), new Servo(28, 1500));

            // legs
            LeftFront = new Leg(new Servo(16, 1500), new Servo(17, 1500),
                                new Servo(18, 1500), Leg.LEFT);
            LeftCenter = new Leg(new Servo(20, 1500), new Servo(21, 1500),
                                new Servo(22, 1500), Leg.LEFT);
            LeftRear = new Leg(new Servo(24, 1500), new Servo(25, 1500),
                                new Servo(26, 1500), Leg.LEFT);

            RightFront = new Leg(new Servo(0, 1500), new Servo(1, 1500),
                                new Servo(2, 1500), Leg.RIGHT);
            RightCenter = new Leg(new Servo(4, 1500), new Servo(5, 1500),
                                new Servo(6, 1500), Leg.RIGHT);
            RightRear = new Leg(new Servo(8, 1500), new Servo(9, 1500),
                                new Servo(10, 1500), Leg.RIGHT);
        }

        /// <summary>
        /// Update communication port
        /// </summary>
        /// <param name="port"></param>
        public void SetPort(SerialPort port)
        {
            Port =  new Connector(port);
        }

        /// <summary>
        /// Initiate Robot's position
        /// </summary>
        public void Init()
        {
            Port.SendCommand(START_UP);
            Reset();
        }

        /// <summary>
        /// Shutdown
        /// </summary>
        public void Shutdown()
        {
            Reset();
            Port.SendCommand(SHUT_DOWN);
        }

        /// <summary>
        /// Reset all leg to initial position
        /// </summary>
        public void Reset()
        {
            string cmd = head.Reset() +
                         LeftFront.Reset(Leg.DefaultLeft) + LeftCenter.Reset(Leg.DefaultLeft) +
                         LeftRear.Reset(Leg.DefaultLeft) +
                         RightFront.Reset(Leg.DefaultRight) + RightCenter.Reset(Leg.DefaultRight) +
                         RightRear.Reset(Leg.DefaultRight);
            Port.SendCommand(cmd);
            //TODO: remove
            System.Threading.Thread.Sleep(100);
        }

        #region Legs Control
        /* 
         * Tripod A: LeftFront, RightCenter, LeftRear
         * Tripod B: RightFront, LeftCenter, RightRear
         */

        /// <summary>
        /// Query movement status
        /// </summary>
        /// <returns></returns>
        //public bool IsMoving()
        //{
        //    // send query command
        //    Port.SendCommand("Q");
        //    // get response
        //    return (Port.ReadResponse() == '+');
        //}

        /// <summary>
        /// Check if previous action has completed
        /// </summary>
        /// <param name="retry">Retry Times</param>
        /// <param name="time">Waiting time</param>
        /// <returns></returns>
        private bool IsDone(int retry, int time)
        {
            // Waiting
            // TODO: implement
            return true;
        }

        /// <summary>
        /// Raise an error notification
        /// </summary>
        /// <param name="msg"></param>
        private void Error(String msg)
        {
            throw new TimeoutException(msg);
        }

        /// <summary>
        /// Moving forward's sequence
        /// </summary>
        /// <param name="height">Step height</param>
        /// <param name="width">Step width</param>
        /// <param name="cycle">Number of sequence's loop</param>
        /// <param name="time">Execution time of 1 cycle</param>
        public void Forward(int height, int width, int cycle, int time)
        {
            //* States   |Tripod A     |Tripod B
            //* Init     |Mid,Center   |Mid,Center
            //* 0        |Low,Center   |High,Center
            string cmd = LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                         LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                         RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                         RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
            Port.SendCommand(cmd, time);

            for (int i = 0; i < cycle; i++)
            {
                //* 1        |Low,Rear     |Mid,Front       [---------------------------------]
                #region Step 1
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Center to Rear*/
                    LeftFront.Backward(width) + RightCenter.Backward(width) + LeftRear.Backward(width) +
                    /*B: Center to Front*/
                    RightFront.Forward(width) + LeftCenter.Forward(width) + RightRear.Forward(width) +
                    /*B: High to Mid*/
                    RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 2        |Low,Rear     |Low,Front       [---------------------------------]
                #region Step 2
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd =
                    /*B: Mid to Low*/
                    RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 3        |Mid,Rear     |Low,Front       [---------------------------------]
                #region Step 3
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Low to Mid*/
                    LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 4        |High,Center  |Low,Center      [---------------------------------]
                #region Step 4
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Mid to High*/
                    LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand()+
                    /*A: Rear to Center*/
                    LeftFront.Forward(width) + RightCenter.Forward(width) + LeftRear.Forward(width) +
                    /*B: Front to Center*/
                    RightFront.Backward(width) + LeftCenter.Backward(width) + RightRear.Backward(width);
                Port.SendCommand(cmd, time);
                #endregion

                //* 5        |Mid,Front    |Low,Rear        [---------------------------------]
                #region Step 5
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: High to Mid*/
                    LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand()+
                    /*A: Center to Front*/
                    LeftFront.Forward(width) + RightCenter.Forward(width) + LeftRear.Forward(width) +
                    /*B: Center to Rear*/
                    RightFront.Backward(width) + LeftCenter.Backward(width) + RightRear.Backward(width);
                Port.SendCommand(cmd, time);
                #endregion

                //* 6        |Low,Front    |Low,Rear        [---------------------------------]
                #region Step 6
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Mid to Low*/
                    LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 7        |Low,Front    |Mid,Rear        [---------------------------------]
                #region Step 7
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*B: Low to Mid*/
                    RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 0        |Low,Center   |High,Center     [---------------------------------]
                #region Step 0
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Front to Center*/
                    LeftFront.Backward(width) + RightCenter.Backward(width) + LeftRear.Backward(width) +
                    /*B: Mid to High*/
                    RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand() +
                    /*B: Rear to Center*/
                    RightFront.Forward(width) + LeftCenter.Forward(width) + RightRear.Forward(width);

                Port.SendCommand(cmd, time);
                #endregion
            }

            // Reset to initial position
            System.Threading.Thread.Sleep(time + 50);
            //* Init     |Mid,Center   |Mid,Center
            cmd = /*A: Low to Mid*/
                LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                /*B: High to Mid*/
                RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();

            Port.SendCommand(cmd, time);
        }

        /// <summary>
        /// Moving backward's sequence
        /// </summary>
        /// <param name="height">Step height</param>
        /// <param name="width">Step width</param>
        /// <param name="cycle">Number of sequence's loop</param>
        /// <param name="time">Execution time of 1 cycle</param>
        public void Backward(int height, int width, int cycle, int time)
        {
            String cmd;
            //* States   |Tripod A     |Tripod B
            //* Init     |Mid,Center   |Mid,Center
            //* 0        |Low,Center   |High,Center
            cmd = LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                  LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                  RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                  RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();

            Port.SendCommand(cmd, time);

            for (int i = 0; i < cycle; i++)
            {

                //* 1        |Low,Front     |Mid,Rear       [---------------------------------]
                #region Step 1
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Center to Front*/
                    LeftFront.Forward(width) + RightCenter.Forward(width) + LeftRear.Forward(width) +
                    /*B: Center to Rear*/
                    RightFront.Backward(width) + LeftCenter.Backward(width) + RightRear.Backward(width) +
                    /*B: High to Mid*/
                    RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 2        |Low,Front     |Low,Rear       [---------------------------------]
                #region Step 2
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd =
                    /*B: Mid to Low*/
                    RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 3        |Mid,Front     |Low,Rear       [---------------------------------]
                #region Step 3
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Low to Mid*/
                    LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 4        |High,Center  |Low,Center      [---------------------------------]
                #region Step 4
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Mid to High*/
                    LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                    /*A: Front to Center*/
                    LeftFront.Backward(width) + RightCenter.Backward(width) + LeftRear.Backward(width) +
                    /*B: Rear to Center*/
                    RightFront.Forward(width) + LeftCenter.Forward(width) + RightRear.Forward(width);
                Port.SendCommand(cmd, time);
                #endregion

                //* 5        |Mid,Rear    |Low,Front        [---------------------------------]
                #region Step 5
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: High to Mid*/
                    LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                    /*A: Center to Rear*/
                    LeftFront.Backward(width) + RightCenter.Backward(width) + LeftRear.Backward(width) +
                    /*B: Center to Front*/
                    RightFront.Forward(width) + LeftCenter.Forward(width) + RightRear.Forward(width);
                Port.SendCommand(cmd, time);
                #endregion

                //* 6        |Low,Rear    |Low,Front        [---------------------------------]
                #region Step 6
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Mid to Low*/
                    LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 7        |Low,Rear    |Mid,Front        [---------------------------------]
                #region Step 7
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*B: Low to Mid*/
                    RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 0        |Low,Center   |High,Center     [---------------------------------]
                #region Step 0
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /* A: Rear to Center*/
                    LeftFront.Forward(width) + RightCenter.Forward(width) + LeftRear.Forward(width) +
                    /* B: Mid to High*/
                    RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand() +
                    /*Front to Center*/
                    RightFront.Backward(width) + LeftCenter.Backward(width) + RightRear.Backward(width);
                
                Port.SendCommand(cmd, time);
                #endregion
            }

            // Reset to initial position
            System.Threading.Thread.Sleep(time + 50);
            //* Init     |Mid,Center   |Mid,Center
            cmd = /*A: Low to Mid*/
                LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                /*B: High to Mid*/
                RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();

            Port.SendCommand(cmd, time);
        }

        /// <summary>
        /// Turning left's sequence
        /// </summary>
        /// <param name="height">Step height</param>
        /// <param name="width">Step width</param>
        /// <param name="cycle">Number of sequence's loop</param>
        /// <param name="time">Execution time of 1 step</param>
        public void TurnLeft(int height, int width, int cycle, int time)
        {
            String cmd;
            // Left
            //* States   |Tripod A     |Tripod B
            //* Init     |Mid,Center   |Mid,Center
            //* 0        |Low,Center   |High,Center 
            cmd = /* A: Mid to Low*/
                LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                /* B: Mid to High*/
                RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();

            Port.SendCommand(cmd, time);

            for (int i = 0; i < cycle; i++)
            {
                
                //* 1        |Low,Right     |Mid,Left       [---------------------------------]
                #region Step 1
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Center to Right*/
                    LeftFront.Forward(width) + RightCenter.Backward(width) + LeftRear.Forward(width) +
                    /*B: Center to Left*/
                    RightFront.Forward(width) + LeftCenter.Backward(width) + RightRear.Forward(width) +
                    /*B: High to Mid*/
                    RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 2        |Low,Right     |Low,Left       [---------------------------------]
                #region Step 2
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*B: Mid to Low*/
                    RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 3        |Mid,Right     |Low,Left       [---------------------------------]
                #region Step 3
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Low to Mid*/
                    LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 4        |High,Center  |Low,Center      [---------------------------------]
                #region Step 4
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Mid to High*/
                    LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                    /*A: Right to Center*/
                    LeftFront.Backward(width) + RightCenter.Forward(width) + LeftRear.Backward(width) +
                    /*B: Left to Center*/
                    RightFront.Backward(width) + LeftCenter.Forward(width) + RightRear.Backward(width);
                Port.SendCommand(cmd, time);
                #endregion

                //* 5        |Mid,Left    |Low,Right        [---------------------------------]
                #region Step 5
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: High to Mid*/
                    LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                    /*A: Center to Left*/
                    LeftFront.Backward(width) + RightCenter.Forward(width) + LeftRear.Backward(width) +
                    /*B: Center to Right*/
                    RightFront.Backward(width) + LeftCenter.Forward(width) + RightRear.Backward(width);
                Port.SendCommand(cmd, time);
                #endregion

                //* 6        |Low,Left    |Low,Right        [---------------------------------]
                #region Step 6
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Mid to Low*/
                    LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 7        |Low,Left    |Mid,Right        [---------------------------------]
                #region Step 7
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*B: Low to Mid*/
                    RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 0        |Low,Center   |High,Center     [---------------------------------]
                #region Step 0
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /* A: Left to Center*/
                    LeftFront.Forward(width) + RightCenter.Backward(width) + LeftRear.Forward(width) +
                    /* B: Mid to High */
                    RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand() +
                    /* B: Right to Center */
                    RightFront.Forward(width) + LeftCenter.Backward(width) + RightRear.Forward(width);

                Port.SendCommand(cmd, time);
                #endregion
            }

            // Reset to initial position
            System.Threading.Thread.Sleep(time + 50);
            //* Init     |Mid,Center   |Mid,Center
            cmd = /*A: Low to Mid*/
                LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                /*B: High to Mid*/
                RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();

            Port.SendCommand(cmd, time);
        }

        /// <summary>
        /// Turning right's sequence
        /// </summary>
        /// <param name="height">Step height</param>
        /// <param name="width">Step width</param>
        /// <param name="cycle">Number of sequence's loop</param>
        /// <param name="time">Execution time of 1 step</param>
        public void TurnRight(int height, int width, int cycle, int time)
        {
            String cmd;
            //* States   |Tripod A     |Tripod B
            //* Init     |Mid,Center   |Mid,Center
            //* 0        |Low,Center   |High,Center
            cmd = /* A: Mid to Low */
                LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                /* B: Mid to High */
                RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();

            Port.SendCommand(cmd, time);

            for (int i = 0; i < cycle; i++)
            {
                //* 1        |Low,Left     |Mid,Right       [---------------------------------]
                #region Step 1
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Center to Left*/
                    LeftFront.Backward(width) + RightCenter.Forward(width) + LeftRear.Backward(width) +
                    /*B: Center to Right*/
                    RightFront.Backward(width) + LeftCenter.Forward(width) + RightRear.Backward(width) +
                    /*B: High to Mid*/
                    RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 2        |Low,Left     |Low,Right       [---------------------------------]
                #region Step 2
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd =
                    /*B: Mid to Low*/
                    RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 3        |Mid,Left     |Low,Right       [---------------------------------]
                #region Step 3
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Low to Mid*/
                    LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 4        |High,Center  |Low,Center      [---------------------------------]
                #region Step 4
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Mid to High*/
                    LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                    /*A: Left to Center*/
                    LeftFront.Forward(width) + RightCenter.Backward(width) + LeftRear.Forward(width) +
                    /*B: Right to Center*/
                    RightFront.Forward(width) + LeftCenter.Backward(width) + RightRear.Forward(width);
                Port.SendCommand(cmd, time);
                #endregion

                //* 5        |Mid,Right    |Low,Left        [---------------------------------]
                #region Step 5
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: High to Mid*/
                    LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                    /*A: Center to Right*/
                    LeftFront.Forward(width) + RightCenter.Backward(width) + LeftRear.Forward(width) +
                    /*B: Center to Left*/
                    RightFront.Forward(width) + LeftCenter.Backward(width) + RightRear.Forward(width);
                Port.SendCommand(cmd, time);
                #endregion

                //* 6        |Low,Right    |Low,Left        [---------------------------------]
                #region Step 6
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*A: Mid to Low*/
                    LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height) +
                    LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion

                //* 7        |Low,Right    |Mid,Left        [---------------------------------]
                #region Step 7
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = /*B: Low to Mid*/
                    RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                    RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
                Port.SendCommand(cmd, time);
                #endregion
                
                //* 0        |Low,Center   |High,Center     [---------------------------------]
                #region Step 0
                // Waiting
                System.Threading.Thread.Sleep(time + 50);

                cmd = LeftFront.Backward(width) + RightCenter.Forward(width) + LeftRear.Backward(width) +
                      RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height) +
                      RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand() +
                      RightFront.Backward(width) + LeftCenter.Forward(width) + RightRear.Backward(width);

                Port.SendCommand(cmd, time);
                #endregion
            }

            // Reset to initial position
            System.Threading.Thread.Sleep(time + 50);
            //* Init     |Mid,Center   |Mid,Center
            cmd = /*A: Low to Mid*/
                LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height) +
                LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand() +
                /*B: High to Mid*/
                RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height) +
                RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();

            Port.SendCommand(cmd, time);
        }

        /// <summary>
        /// Strafe's sequence
        /// </summary>
        /// <param name="height">Step height: *unused*</param>
        /// <param name="width">Step width: *unused*</param>
        /// <param name="cycle">number of loop</param>
        /// <param name="time">Execution time</param>
        public void StrafeLeft(int height, int width, int cycle, int time)
        {
            String cmd;
            // Left
            //* States   |Tripod A     |Tripod B
            //* Init     |Mid,Center   |Mid,Center

            for (int i = 0; i < cycle; i++)
            {
                //* 0        |Low,Center   |High,Center     [---------------------------------]
                #region Step 0
                // Waiting
                System.Threading.Thread.Sleep(time + 200);

                cmd = // A
                        LeftFront.FixPosition(1500, 1400, 1400) +
                        RightCenter.FixPosition(1500, 1600, 1600) +
                        LeftRear.FixPosition(1500, 1400, 1400) +
                    // B
                        RightFront.FixPosition(1500, 2000, 2000) +
                        LeftCenter.FixPosition(1500, 1000, 1000) +
                        RightRear.FixPosition(1500, 2000, 2000);

                Port.SendCommand(cmd, time);
                #endregion

                //* 1        |Low,Right     |Mid,Left       [---------------------------------]
                #region Step 1
                // Waiting
                System.Threading.Thread.Sleep(time + 200);

                cmd = // A
                        LeftFront.FixPosition(1420, 1440, 1280) +
                        RightCenter.FixPosition(1500, 1560, 1400) +
                        LeftRear.FixPosition(1620, 1440, 1280) +
                    // B
                        RightFront.FixPosition(1580, 1760, 1720) +
                        LeftCenter.FixPosition(1500, 1240, 1600) +
                        RightRear.FixPosition(1380, 1760, 1720);

                Port.SendCommand(cmd, time);
                #endregion

                //* 2        |Low,Right     |Low,Left       [---------------------------------]
                #region Step 2
                // Waiting
                System.Threading.Thread.Sleep(time + 200);

                cmd = // A
                        LeftFront.FixPosition(1420, 1440, 1280) +
                        RightCenter.FixPosition(1500, 1560, 1400) +
                        LeftRear.FixPosition(1620, 1440, 1280) +
                    // B
                        RightFront.FixPosition(1580, 1560, 1720) +
                        LeftCenter.FixPosition(1500, 1440, 1600) +
                        RightRear.FixPosition(1380, 1560, 1720);

                Port.SendCommand(cmd, time);
                #endregion

                //* 3        |Mid,Right     |Low,Left       [---------------------------------]
                #region Step 3
                // Waiting
                System.Threading.Thread.Sleep(time + 200);

                cmd = // A
                        LeftFront.FixPosition(1420, 1240, 1280) +
                        RightCenter.FixPosition(1500, 1760, 1400) +
                        LeftRear.FixPosition(1620, 1240, 1280) +
                    // B
                        RightFront.FixPosition(1580, 1560, 1720) +
                        LeftCenter.FixPosition(1500, 1440, 1600) +
                        RightRear.FixPosition(1380, 1560, 1720);
                Port.SendCommand(cmd, time);
                #endregion

                //* 4        |High,Center  |Low,Center      [---------------------------------]
                #region Step 4
                // Waiting
                System.Threading.Thread.Sleep(time + 200);

                cmd = // A
                        LeftFront.FixPosition(1500, 1000, 1000) +
                        RightCenter.FixPosition(1500, 2000, 2000) +
                        LeftRear.FixPosition(1500, 1000, 1000) +
                    // B
                        RightFront.FixPosition(1500, 1600, 1600) +
                        LeftCenter.FixPosition(1500, 1400, 1400) +
                        RightRear.FixPosition(1500, 1600, 1600);
                Port.SendCommand(cmd, time);
                #endregion

                //* 5        |Mid,Left    |Low,Right        [---------------------------------]
                #region Step 5
                // Waiting
                System.Threading.Thread.Sleep(time + 200);

                cmd = // A
                        LeftFront.FixPosition(1620, 1240, 1600) +
                        RightCenter.FixPosition(1500, 1760, 1720) +
                        LeftRear.FixPosition(1420, 1240, 1600) +
                    // B
                        RightFront.FixPosition(1380, 1560, 1400) +
                        LeftCenter.FixPosition(1500, 1440, 1280) +
                        RightRear.FixPosition(1580, 1560, 1400);

                Port.SendCommand(cmd, time);
                #endregion

                //* 6        |Low,Left    |Low,Right        [---------------------------------]
                #region Step 6
                // Waiting
                System.Threading.Thread.Sleep(time + 200);
                cmd = // A
                        LeftFront.FixPosition(1620, 1440, 1600) +
                        RightCenter.FixPosition(1500, 1560, 1720) +
                        LeftRear.FixPosition(1420, 1440, 1600) +
                    // B
                        RightFront.FixPosition(1380, 1560, 1400) +
                        LeftCenter.FixPosition(1500, 1440, 1280) +
                        RightRear.FixPosition(1580, 1560, 1400);
                Port.SendCommand(cmd, time);
                #endregion

                //* 7        |Low,Left    |Mid,Right        [---------------------------------]
                #region Step 7
                // Waiting
                System.Threading.Thread.Sleep(time + 200);

                cmd = // A
                        LeftFront.FixPosition(1620, 1440, 1600) +
                        RightCenter.FixPosition(1500, 1560, 1720) +
                        LeftRear.FixPosition(1420, 1440, 1600) +
                    // B
                        RightFront.FixPosition(1380, 1760, 1400) +
                        LeftCenter.FixPosition(1500, 1240, 1280) +
                        RightRear.FixPosition(1580, 1760, 1400);

                Port.SendCommand(cmd, time);
                #endregion

                
            }

            // Reset to initial position
            System.Threading.Thread.Sleep(time + 200);
            //* Init     |Mid,Center   |Mid,Center
            cmd = LeftFront.Reset(Leg.DefaultLeft) +
                  LeftCenter.Reset(Leg.DefaultLeft) +
                  LeftRear.Reset(Leg.DefaultLeft) +
                  RightFront.Reset(Leg.DefaultRight) +
                  RightCenter.Reset(Leg.DefaultRight) +
                  RightRear.Reset(Leg.DefaultRight);

            Port.SendCommand(cmd, time);
        }

        /// <summary>
        /// Rotate apod body
        /// </summary>
        /// <param name="interval">Moving distance</param>
        /// <param name="direction">Rotating direction</param>
        /// <param name="time">Execution time</param>
        public void Rotate(int interval, Direction direction, int time)
        {
            String cmd = "";
            switch (direction.Name)
            {
                case "Left": //left
                    cmd = LeftFront.Lift(interval) + LeftCenter.Lift(interval) + LeftRear.Lift(interval) +
                          LeftFront.Stand() + LeftCenter.Stand() + LeftRear.Stand() +
                          RightFront.Drop(interval) + RightCenter.Drop(interval) + RightRear.Drop(interval) +
                          RightFront.Stand() + RightCenter.Stand() + RightRear.Stand();
                    break;
                case "Right": //right
                    cmd = LeftFront.Drop(interval) + LeftCenter.Drop(interval) + LeftRear.Drop(interval) +
                          LeftFront.Stand() + LeftCenter.Stand() + LeftRear.Stand() +
                          RightFront.Lift(interval) + RightCenter.Lift(interval) + RightRear.Lift(interval) +
                          RightFront.Stand() + RightCenter.Stand() + RightRear.Stand();
                    break;
                case "Backward": //backward
                    cmd = LeftFront.Drop(interval) + RightFront.Drop(interval) +
                          LeftFront.Stand() + RightFront.Stand() +
                          LeftRear.Lift(interval) + RightRear.Lift(interval) +
                          LeftRear.Stand() + RightRear.Stand();
                    break;
                case "Forward": //Foward
                    cmd = LeftFront.Lift(interval) + RightFront.Lift(interval) +
                          LeftFront.Stand() + RightFront.Stand() +
                          LeftRear.Drop(interval) + RightRear.Drop(interval) +
                          LeftRear.Stand() + RightRear.Stand();
                    break;
            }
            Port.SendCommand(cmd, time);
        }

        /// <summary>
        /// Change body height
        /// </summary>
        /// <param name="interval">Negative to lift the body, Positive to drop.</param>
        /// <param name="direction"></param>
        public void Push(int interval, Direction direction, int time)
        {
            String cmd= "";
            switch (direction.Name)
            {
                case "Up":
                    cmd = LeftFront.Drop(interval) + LeftCenter.Drop(interval) + LeftRear.Drop(interval) +
                          LeftFront.Stand() + LeftCenter.Stand() + LeftRear.Stand() +
                          RightFront.Drop(interval) + RightCenter.Drop(interval) + RightRear.Drop(interval) +
                          RightFront.Stand() + RightCenter.Stand() + RightRear.Stand();
                    break;
                case "Down":
                    cmd = LeftFront.Lift(interval) + LeftCenter.Lift(interval) + LeftRear.Lift(interval) +
                          LeftFront.Stand() + LeftCenter.Stand() + LeftRear.Stand() +
                          RightFront.Lift(interval) + RightCenter.Lift(interval) + RightRear.Lift(interval) +
                          RightFront.Stand() + RightCenter.Stand() + RightRear.Stand();
                    break;
                case "Left": //left
                    cmd = LeftFront.Forward(interval) + LeftCenter.Forward(interval) + LeftRear.Forward(interval) +
                          RightFront.Backward(interval) + RightCenter.Backward(interval) + RightRear.Backward(interval);
                    break;
                case "Right": //right
                    cmd = LeftFront.Backward(interval) + LeftCenter.Backward(interval) + LeftRear.Backward(interval) +
                          RightFront.Forward(interval) + RightCenter.Forward(interval) + RightRear.Forward(interval);
                    break;
                case "Backward": //backward
                    cmd = LeftFront.Forward(interval) + LeftCenter.Forward(interval) + LeftRear.Forward(interval) +
                          RightFront.Forward(interval) + RightCenter.Forward(interval) + RightRear.Forward(interval);
                    break;
                case "Forward": //Foward
                    cmd = LeftFront.Backward(interval) + LeftCenter.Backward(interval) + LeftRear.Backward(interval) +
                          RightFront.Backward(interval) + RightCenter.Backward(interval) + RightRear.Backward(interval);
                    break;
            }
            Port.SendCommand(cmd, time);
        } 

        #endregion

        #region Head Control
        /// <summary>
        /// Turn head up/down/left/right
        /// </summary>
        /// <param name="interval">Moving Distance</param>
        /// <param name="direction">Turning direction up/down/left/right</param>
        /// <param name="time">Execution time</param>
        public void HeadTurn(int interval, Direction direction, int time)
        {
            String cmd = head.Turn(interval, direction);
            Port.SendCommand(cmd, time);
        }

        /// <summary>
        /// Rotate head (change head's balance)
        /// </summary>
        /// <param name="interval">Moving Distance</param>
        /// <param name="direction">Rotate direction: left/right</param>
        /// <param name="time">Execution time</param>
        public void HeadRotate(int interval, Direction direction, int time)
        {
            String cmd = head.Rotate(interval, direction);
            Port.SendCommand(cmd, time);
        }

        /// <summary>
        /// Auto grip object
        /// </summary>
        public void Grip()
        {
            bool done = false;
            int force = 0;
            
            while (!done)
            {;
                force = Port.Read(new[] {(byte) 'V', (byte) 'A'});
                if (force > 0)
                {
                    force = Port.Read(new[] { (byte)'V', (byte)'A' });
                    done = (force > 0);
                }
                else
                {
                    Grip(20, 20);
                }
            }
        }

        /// <summary>
        /// Close down mandibles
        /// </summary>
        /// <param name="interval">Moving Distance</param>
        /// <param name="time">Execution time</param>
        public void Grip(int interval, int time)
        {
            String cmd = head.Grip(interval);
            Port.SendCommand(cmd, time);
        }

        /// <summary>
        /// Auto Release object
        /// </summary>
        public void Loose()
        {
            bool done = false;
            int force = 5;

            while (!done)
            {
                ;
                force = Port.Read(new[] { (byte)'V', (byte)'A' });
                if (force > 0)
                {
                    Loose(20, 20);
                }
                else
                {
                    force = Port.Read(new[] { (byte)'V', (byte)'A' });
                    done = (force == 0);
                    Loose(100, 20);
                }
            }
        }

        /// <summary>
        /// Release mandibles
        /// </summary>
        /// <param name="interval">Moving Distance</param>
        /// <param name="time">Execution time</param>
        public void Loose(int interval, int time)
        {
            String cmd = head.Loose(interval);
            Port.SendCommand(cmd, time);
        }
        #endregion

        #region Tripod A Manipulate
        public void TripodA_Lift(int height, int time)
        {
            String cmd = LeftFront.Lift(height) + RightCenter.Lift(height) + LeftRear.Lift(height);
            Port.SendCommand(cmd, time);
        }

        public void TripodA_Forward(int width, int time)
        {
            String cmd = LeftFront.Forward(width) + RightCenter.Forward(width) + LeftRear.Forward(width);
            Port.SendCommand(cmd, time);
        }

        public void TripodA_Drop(int height, int time)
        {
            String cmd = LeftFront.Drop(height) + RightCenter.Drop(height) + LeftRear.Drop(height);
            Port.SendCommand(cmd, time);
        }

        public void TripodA_Backward(int width, int time)
        {
            String cmd = LeftFront.Backward(width) + RightCenter.Backward(width) + LeftRear.Backward(width);
            Port.SendCommand(cmd, time);
        }

        public void TripodA_TurnLeft(int width, int time)
        {
            String cmd = LeftFront.Backward(width) + RightCenter.Forward(width) + LeftRear.Backward(width);
            Port.SendCommand(cmd, time);
        }

        public void TripodA_TurnRight(int width, int time)
        {
            String cmd = LeftFront.Forward(width) + RightCenter.Backward(width) + LeftRear.Forward(width);
            Port.SendCommand(cmd, time);
        }

        public void TripodA_StretchLeft(int height, int time)
        {
            String cmd = LeftFront.Backward(100) + LeftFront.Drop(200) + LeftFront.Stretch(600) +
                         LeftRear.Forward(100) + LeftRear.Drop(200) + LeftRear.Stretch(600) +
                         RightCenter.Middle(Leg.DefaultRight);
            Port.SendCommand(cmd, time);
        }

        public void TripodA_StretchRight(int height, int time)
        {
            String cmd = LeftFront.Middle(Leg.DefaultLeft) + RightCenter.Stretch(600) + LeftRear.Middle(Leg.DefaultLeft) +
                         RightCenter.Drop(200);
            Port.SendCommand(cmd, time);
        }

        public void TripodA_Stand(int none, int time)
        {
            String cmd = LeftFront.Stand() + RightCenter.Stand() + LeftRear.Stand();
            Port.SendCommand(cmd, time);
        }

        public void TripodA_Center(int none, int time)
        {
            String cmd = LeftFront.Middle(Leg.DefaultLeft) + RightCenter.Middle(Leg.DefaultRight) + LeftRear.Middle(Leg.DefaultLeft);
            Port.SendCommand(cmd, time);
        }

        #endregion

        #region Tripod B Manipulate
        public void TripodB_Lift(int height, int time)
        {
            String cmd = RightFront.Lift(height) + LeftCenter.Lift(height) + RightRear.Lift(height);
            Port.SendCommand(cmd, time);
        }

        public void TripodB_Forward(int width, int time)
        {
            String cmd = RightFront.Forward(width) + LeftCenter.Forward(width) + RightRear.Forward(width);
            Port.SendCommand(cmd, time);
        }

        public void TripodB_Drop(int height, int time)
        {
            String cmd = RightFront.Drop(height) + LeftCenter.Drop(height) + RightRear.Drop(height);
            Port.SendCommand(cmd, time);
        }

        public void TripodB_Backward(int width, int time)
        {
            String cmd = RightFront.Backward(width) + LeftCenter.Backward(width) + RightRear.Backward(width);
            Port.SendCommand(cmd, time);
        }

        public void TripodB_TurnLeft(int width, int time)
        {
            String cmd = RightFront.Forward(width) + LeftCenter.Backward(width) + RightRear.Forward(width);
            Port.SendCommand(cmd, time);
        }

        public void TripodB_TurnRight(int width, int time)
        {
            String cmd = RightFront.Backward(width) + LeftCenter.Forward(width) + RightRear.Backward(width);
            Port.SendCommand(cmd, time);
        }

        public void TripodB_StretchLeft(int height, int time)
        {
            String cmd = RightFront.Middle(Leg.DefaultRight) + LeftCenter.Stretch(600) +
                         RightRear.Middle(Leg.DefaultRight) + LeftCenter.Drop(200);
            Port.SendCommand(cmd, time);
        }

        public void TripodB_StretchRight(int height, int time)
        {
            //String cmd = RightFront.Stretch(600) + LeftCenter.Middle(Leg.DefaultLeft) + RightRear.Stretch(600) +
            //             RightFront.Drop(200) + RightRear.Drop(200);
            String cmd = RightFront.Backward(100) + RightFront.Stretch(600) + RightFront.Drop(200) +
                         RightRear.Forward(100) + RightRear.Stretch(600) + RightRear.Drop(200) +
                         LeftCenter.Middle(Leg.DefaultLeft);
            Port.SendCommand(cmd, time);
        }

        public void TripodB_Stand(int none, int time)
        {
            String cmd = RightFront.Stand() + LeftCenter.Stand() + RightRear.Stand();
            Port.SendCommand(cmd, time);
        }

        public void TripodB_Center(int none, int time)
        {
            String cmd = RightFront.Middle(Leg.DefaultRight) + LeftCenter.Middle(Leg.DefaultLeft) + RightRear.Middle(Leg.DefaultRight);
            Port.SendCommand(cmd, time);
        }
        #endregion
    }
}
