with Text_IO; use Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Containers.Vectors;
with ada.numerics.discrete_random;


with Message_Graph; use Message_Graph;
with Graph_Tasks; use Graph_Tasks;

procedure main is

   n : Integer := 8;
   d : Integer := 5;
   k : Integer := 7;
   b : Integer := 4;
   h : Integer := 8;

   procedure Get_Parameters is
   begin
      if Argument_Count < 3 then
         Put_Line("Musisz podac parametry: <wierzcholki> <skroty> <drogi_powrotne> <wiadomosci> <okres_zycia>");
      else
         n := Integer'Value(Argument(1));
         d := Integer'Value(Argument(2));
         b := Integer'Value(Argument(3));
         k := Integer'Value(Argument(4));
         h := Integer'Value(Argument(5));
      end if;
   end;

   type randRange is range 0 .. 100000;
   package Rand_Int is new ada.numerics.discrete_random(randRange);
   use Rand_Int;
   gen : Generator;

   package Node_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Node_Access);
   nodes : Node_Vectors.Vector;

   channels : Channel_Vectors.Vector;

   package Packet_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Packet_Access);
   packets : Packet_Vectors.Vector;

   procedure Print_Graph(nodes: in Node_Vectors.Vector) is
   begin
      for node of nodes loop
         Put(Integer'Image (node.index) & "---> ");
         for channel of channels loop
            if channel.beginNode = node.index then
               Put(Integer'Image (channel.endNode) & " ");
            end if;
         end loop;
         Put_Line("");
      end loop;
      Put_Line("______________________________");
   end;

   procedure Print_Results(nodes: in Node_Vectors.Vector; channels: in Channel_Vectors.Vector; packets: in Packet_Vectors.Vector) is
   begin
      Put_Line("______________________________");
      Put_Line("Node: Obsluzone pakiety");
      for node of nodes loop
         Put(Integer'Image (node.index) & ":  ");
         for msg_index of node.servedPackets loop
            Put(Integer'Image (msg_index) & " ");
         end loop;
         Put_Line("");
      end loop;
      Put_Line("______________________________");
      Put_Line("Packet: Odwiedzone wierzcholki");
      for packet of packets loop
         Put(Integer'Image (packet.index) & ":  ");
         for msg_index of packet.visitedNodes loop
            Put(Integer'Image (msg_index) & " ");
         end loop;
         Put_Line("");
      end loop;
   end;

   procedure Init_NodeVector( Size: in Integer; nodes: in out Node_Vectors.Vector; channels: in Channel_Vectors.Vector) is
      inputPipes: Channel_Vectors.Vector;
      outputPipes: Channel_Vectors.Vector;
   begin
      for I in 0 .. Size-1 loop
         inputPipes := Channel_Vectors.Empty_Vector;
         outputPipes := Channel_Vectors.Empty_Vector;
         for channel of channels loop
            if channel.beginNode = I then
               outputPipes.Append(channel);
            end if;
            if channel.endNode = I then
               inputPipes.Append(channel);
            end if;
         end loop;
         nodes.Append(new Node'(I, inputPipes, outputPipes, Integer_Vectors.Empty_Vector));
      end loop;
   end;

   procedure Init_ChannelVector( n: in Integer; d: in Integer; b: in Integer; channels: in out Channel_Vectors.Vector ) is
      val : Integer;
      Begin_Node : Integer;
      End_Node : Integer;
   begin
      for I in 0 .. n-2 loop
         channels.Append(new Channel'(I, new Pipe, I, I+1));
      end loop;

      reset(gen);
      for I in n-1 .. n-1+d-1 loop
         Begin_Node := (Integer(random(gen)) mod (n-1));
         val := (n - Begin_Node - 1);
         if val = 0 then
            End_Node := (Begin_Node + 1);
         else
            End_Node := (Begin_Node + 1) + (Integer(random(gen)) mod val);
         end if;
         channels.Append(new Channel'(I, new Pipe, Begin_Node, End_Node));
      end loop;

      for I in 0 .. b-1 loop
         Begin_Node := (Integer(random(gen)) mod (n-3)) + 2;
         val := (Begin_Node - 1);
         End_Node := (Integer(random(gen)) mod val) +1;
         channels.Append(new Channel'(I, new Pipe, Begin_Node, End_Node));
      end loop;
   end;

   procedure Init_PacketVector( Size: in Integer; ttl : in Integer; packets: in out Packet_Vectors.Vector ) is
   begin
      for I in 0 .. Size-1 loop
         packets.Append(new Packet'(I, Integer_Vectors.Empty_Vector, ttl));
      end loop;
   end;

   procedure Run_Tasks(nodes: in out Node_Vectors.Vector ) is
      outlet : TaskOutlet_Access;
      junctions : TaskJunctionVector_Access := new Junction_Vectors.Vector;
      source : TaskSource_Access;
      hunter : TaskHunter_Access;
   begin
      source := new TaskSource(nodes(0), k);
      for I in 1 .. n-2 loop
         junctions.Append(new TaskJunction(nodes(I)));
      end loop;
      hunter := new TaskHunter(junctions);
      outlet := new TaskOutlet(nodes(n-1));

      reset(gen);
      for m of packets loop
         delay Duration(Integer(random(gen)) mod 10); -- czekamy losowy czas przed wyslaniem wiadomosci do zrodla
         source.Send(m);
      end loop;

      loop
         if source'Terminated then
            delay Duration(10);
            outlet.Terminate_Outlet;
            for junction of junctions.all loop
               junction.Terminate_Junction;
            end loop;
            exit;
         end if;
      end loop;
   end;

begin
   Get_Parameters;
   Init_ChannelVector(n, d, b, channels);
   Init_PacketVector(k, h, packets);
   Init_NodeVector(n, nodes, channels);
   Print_Graph(nodes);
   Run_Tasks(nodes);
   Print_Results(nodes, channels, packets);
end main;
