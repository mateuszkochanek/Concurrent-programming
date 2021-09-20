with Text_IO; use Text_IO;

package body Graph_Tasks is
   
   task body TaskSource is
      packet : Packet_Access;
      Random_Index : Integer;
      stop : Boolean := False;
      Output_Channels_Count : Integer;
   begin
      reset(gen);
      Output_Channels_Count := Integer(node.outputPipes.Length);
      loop
         select
            accept Send (myPacket : Packet_Access) do
               packet := myPacket;
               Messager.Print("Pakiet "&Integer'Image(packet.index)&" jest w wierzcholku 0");
               delay Duration(Integer(random(gen)) mod Sending_Delay);
               packet.visitedNodes.Append(node.index);
               node.servedPackets.Append(packet.index);
               Random_Index := Integer(random(gen)) mod Output_Channels_Count;
               node.outputPipes(Random_Index).Pipe.Set(packet);
            end Send;
         or
            accept Terminate_Source  do
               stop := True;
            end Terminate_Source;
         end select;
        
         exit when stop;
      end loop;
   end TaskSource;
   
   task body TaskJunction is
      packet : Packet_Access;
      Random_Index : Integer;
      stop : Boolean := False;
      Output_Channels_Count : Integer;
      Input_Channels_Count : Integer;
   begin
      reset(gen);
      Output_Channels_Count := Integer(node.outputPipes.Length);
      Input_Channels_Count := Integer(node.inputPipes.Length);
      loop
         for channel of node.inputPipes loop
            select
               channel.Pipe.Get(packet);
               Messager.Print("Pakiet "&Integer'Image(packet.index)&" jest w wierzcholku" & Integer'Image(node.index));
               delay Duration(Integer(random(gen)) mod Sending_Delay);
               Random_Index := Integer(random(gen)) mod Output_Channels_Count;
               packet.visitedNodes.Append(node.index);
               node.servedPackets.Append(packet.index);
               node.outputPipes(Random_Index).Pipe.Set(packet);
            else
               null;
            end select;
         end loop;
         select 
            accept Terminate_Junction  do
               stop := true;
            end Terminate_Junction;
         else
            null;
         end select;
         
         exit when stop;
      end loop;
   end TaskJunction;
   
   task body TaskOutlet is
      packet : Packet_Access;
      counter : Integer := 0;
   begin
      loop
         delay Duration(Integer(random(gen)) mod Sending_Delay);
         for channel of node.inputPipes loop
            select
               channel.Pipe.Get(packet);
               packet.visitedNodes.Append(node.index);
               node.servedPackets.Append(packet.index);
               counter := counter + 1;
               Messager.Print("Pakiet "&Integer'Image(packet.index)&" zostal odebrany");
            else
               null;
            end select;
         end loop;
         exit when counter = k;
      end loop;
   end TaskOutlet;
   
   task body Messager is
   begin
      loop
         select
            accept Print (msg : in String) do
               Put_Line (msg);
            end Print;
         or
            terminate;
         end select;
      end loop;
   end Messager;
   
   
end Graph_Tasks;
