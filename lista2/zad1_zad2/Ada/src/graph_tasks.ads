with Message_Graph; use Message_Graph;
with Ada.Containers.Vectors;
with ada.numerics.discrete_random;
package Graph_Tasks is
   
   type randRange is range 0 .. 100000;
   package Rand_Int is new ada.numerics.discrete_random(randRange);
   use Rand_Int;
   gen : Generator;
   
   task type TaskJunction(node : Node_Access) is
      entry Terminate_Junction;
      entry Trap_Setup;
   end TaskJunction;
   type TaskJunction_Access is access TaskJunction;
   
   package Junction_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => TaskJunction_Access);
   type TaskJunctionVector_Access is access all Junction_Vectors.Vector;
   
   Sending_Delay : CONSTANT Integer := 5;
   
   task type TaskSource(node : Node_Access; k : Integer) is
      entry Send (myPacket : Packet_Access);
   end TaskSource;
   type TaskSource_Access is access TaskSource;
   
   task type TaskHunter(junctions : TaskJunctionVector_Access) is
      entry Terminate_Hunter;
   end TaskHunter;
   type TaskHunter_Access is access TaskHunter;
   
   task type TaskOutlet(node : Node_Access) is
      entry Terminate_Outlet;
   end TaskOutlet;
   type TaskOutlet_Access is access TaskOutlet;
   
   task Messager is
      entry Print(msg : String);
   end Messager;
   

end Graph_Tasks;
