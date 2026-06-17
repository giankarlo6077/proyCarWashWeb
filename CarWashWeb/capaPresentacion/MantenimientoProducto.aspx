<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="MantenimientoProducto.aspx.vb" Inherits="capaPresentacion_MantenimientoProducto" Title="Mantenimiento de Producto" %>

<asp:Content ID="cTitulo" ContentPlaceHolderID="titulo" runat="server">Mantenimiento de Producto</asp:Content>

<asp:Content ID="cBody" ContentPlaceHolderID="cuerpo" runat="server">

    <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

    <div class="card">
        <h2><img src="<%= ResolveUrl("~/Imagenes/buscar.png") %>" alt="" /> Buscar Productos</h2>
        <div class="searchbar">
            <asp:TextBox ID="txtbuscador" runat="server" placeholder="Buscar por ID o nombre del producto..." />
            <asp:Button ID="btnBuscar" runat="server" CssClass="btn" Text="Buscar" />
            <a class="btn accent" href="GestionarProducto.aspx"><img src="<%= ResolveUrl("~/Imagenes/agregar-producto.png") %>" alt="" /> Gestionar Productos</a>
        </div>
    </div>

    <div class="card">
        <h2><img src="<%= ResolveUrl("~/Imagenes/Productos.png") %>" alt="" /> Productos Vigentes</h2>
        <div class="table-wrap">
            <asp:GridView ID="tblProducto" runat="server" CssClass="grid" AutoGenerateColumns="false" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id" />
                    <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                    <asp:BoundField DataField="stock" HeaderText="Stock" />
                    <asp:BoundField DataField="vigencia" HeaderText="Vigencia" />
                    <asp:BoundField DataField="Precio" HeaderText="Precio" />
                    <asp:BoundField DataField="TipoProducto" HeaderText="Tipo Producto" />
                    <asp:BoundField DataField="Marca" HeaderText="Marca" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>
