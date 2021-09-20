with structures; use structures;
with Ada.Containers.Vectors;
with ada.numerics.discrete_random;
package graph_tasks is

   type randRange is range 0 .. 100000;
   package Rand_Int is new ada.numerics.discrete_random(randRange);
   use Rand_Int;
   gen : Generator;
   
   task type TaskReceiver(myNode : Node_Access) is
      entry Send (myPacket : Packet_Access);
   end TaskReceiver;
   type TaskReceiver_Access is access TaskReceiver;
   
   package Receiver_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => TaskReceiver_Access);
   type ReceiverVector_Access is not null access all Receiver_Vectors.Vector;
   receivers : Receiver_Vectors.Vector;
   
   task type TaskSender(myNode : Node_Access) is
   end TaskSender;
   type TaskSender_Access is access TaskSender;
   
   package Sender_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => TaskSender_Access);
   type SenderVector_Access is access all Sender_Vectors.Vector;
   
   Sending_Delay : CONSTANT Integer := 10;
   
   task Messager is
      entry Print(msg : String);
   end Messager;
   

end graph_tasks;
