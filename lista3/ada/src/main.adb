with Text_IO; use Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Containers.Vectors;
with ada.numerics.discrete_random;


with structures; use structures;
with Graph_Tasks; use Graph_Tasks;
procedure Main is

   n : Integer := 8;
   d : Integer := 1;

   procedure Get_Parameters is
   begin
      if Argument_Count < 2 then
         Put_Line("Musisz podac parametry: <wierzcholki> <skroty>");
      else
         n := Integer'Value(Argument(1));
         d := Integer'Value(Argument(2));
      end if;
   end;

   type randRange is range 0 .. 100000;
   package Rand_Int is new ada.numerics.discrete_random(randRange);
   use Rand_Int;
   gen : Generator;

   nodes : Node_Vectors.Vector;
   edges : Edge_Vectors.Vector;

   procedure Init_Edges(edges: in out Edge_Vectors.Vector) is
      val : Integer;
      Begin_Node : Integer;
      End_Node : Integer;
   begin
      for I in 0 .. n-2 loop
         edges.Append(new Edge'(I, I+1));
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
         edges.Append(new Edge'(Begin_Node, End_Node));
      end loop;
   end;

   procedure Init_Nodes(nodes: in out Node_Vectors.Vector; edges: in Edge_Vectors.Vector) is
      inputPipes: Integer_Vectors.Vector;
   begin
      for I in 0 .. n-1 loop
         nodes.Append(new Node'(I, Integer_Vectors.Empty_Vector, new RoutingTable));
      end loop;
      for edge of edges loop
         nodes(edge.beginNode).neighbours.Append(edge.endNode);
         nodes(edge.endNode).neighbours.Append(edge.beginNode);
      end loop;
      for node of nodes loop
         node.routingTable.generateRoutingTable(n, node.index, node.neighbours);
      end loop;
   end;

   procedure Print_Graph(nodes: in Node_Vectors.Vector) is
   begin
      for node of nodes loop
         Put(Integer'Image (node.index) & "---> ");
         for neighbour of node.neighbours loop
            Put(Integer'Image (neighbour) & " ");
         end loop;
         Put_Line("");
         --node.routingTable.printRoutingTable;
      end loop;
      Put_Line("______________________________");
   end;

   procedure Run_Tasks(nodes: in out Node_Vectors.Vector ) is
      senders : Sender_Vectors.Vector := Sender_Vectors.Empty_Vector;
   begin
      for node of nodes loop
         receivers.Append(new TaskReceiver(node));
      end loop;
      for node of nodes loop
         senders.Append(new TaskSender(node));
      end loop;
   end;

begin
   Get_Parameters;
   Init_Edges(edges);
   Init_Nodes(nodes, edges);
   Print_Graph(nodes);
   Run_Tasks(nodes);
   --Print_Results(nodes, channels, packets);
end Main;
