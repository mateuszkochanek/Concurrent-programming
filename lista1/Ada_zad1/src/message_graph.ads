with Ada.Containers.Vectors;

package Message_Graph is
   
   package Integer_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Integer);
   
   type Packet is record
      index: Integer;
      visitedNodes: Integer_Vectors.Vector;
   end record;
   type Packet_Access is access Packet;
   
   protected type Pipe is
      entry Set(V : in Packet_Access);
      entry Get(V : out Packet_Access);
   private
      Value : Packet_Access;
      Is_Full : Boolean := False;
   end Pipe;
   type Pipe_Access is access Pipe;
   
   type Channel is record
      index: Integer;
      pipe: Pipe_Access;
      beginNode: Integer;
      endNode: Integer;
   end record;
   type Channel_Access is access Channel;
   
   package Channel_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Channel_Access);
   
   type Node is record
      index: Integer;
      inputPipes: Channel_Vectors.Vector;
      outputPipes: Channel_Vectors.Vector;
      servedPackets: Integer_Vectors.Vector;
   end record;
   type Node_Access is access Node;
  
   

end Message_Graph;




