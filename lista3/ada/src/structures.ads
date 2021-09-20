with Ada.Containers.Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_Io; use Ada.Text_IO.Unbounded_IO;
package structures is

   package Integer_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Integer);
   
   type Packet is record
      neighbourIndex: Integer;
      nodeIndexes: Integer_Vectors.Vector;
      costs: Integer_Vectors.Vector;
   end record;
   type Packet_Access is access Packet;
   
   type Edge is record
      beginNode: Integer;
      endNode: Integer;
   end record;
   type Edge_Access is access Edge;
   
   package Edge_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Edge_Access);
   
   type RoutingEntry is record
      nexthop: Integer;
      cost: Integer;
      changed: Boolean;
   end record;
   type RoutingEntry_Access is access RoutingEntry;
   
   package RoutingEntry_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => RoutingEntry_Access);
   type RoutingEntryVector_Access is access all RoutingEntry_Vectors.Vector;
   
   protected type RoutingTable is
      procedure generateRoutingTable (nodeCount: Integer; index : Integer; neighbours: Integer_Vectors.Vector);
      procedure printRoutingTable;
      entry HandlePacket(nodeIndex: Integer; P : in out Packet_Access; msg: in out Unbounded_String);
      entry CreatePacket(P : in out Packet_Access);
   private
      routingEntries :  RoutingEntry_Vectors.Vector;
      inUse : Boolean := False;
   end RoutingTable;
   type RoutingTable_Access is access RoutingTable;

   type Node is record
      index: Integer;
      neighbours: Integer_Vectors.Vector;
      routingTable: RoutingTable_Access;
   end record;
   type Node_Access is access Node;
   
   package Node_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Node_Access);
  
   


end structures;
