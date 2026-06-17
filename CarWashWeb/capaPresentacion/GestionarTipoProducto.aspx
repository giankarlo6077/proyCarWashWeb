<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="GestionarTipoProducto.aspx.vb" Inherits="capaPresentacion_GestionarTipoProducto" Title="Gestionar Tipo de Producto" %>

<asp:Content ID="cTitulo" ContentPlaceHolderID="titulo" runat="server">Gestionar Tipo de Producto</asp:Content>

<asp:Content ID="cBody" ContentPlaceHolderID="cuerpo" runat="server">

    <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

    <div class="card">
        <h2><img src="<%= ResolveUrl("~/Imagenes/agregar-producto.png") %>" alt="" /> Datos del Tipo de Producto</h2>
        <div class="form-grid">
            <div class="field">
                <label>ID Tipo de Producto</label>
                <asp:TextBox ID="txtIdTipoProducto" runat="server" />
            </div>
            <div class="field">
                <label>Nombre</label>
                <asp:TextBox ID="txtNombre" runat="server" />
            </div>
        </div>
        <div class="actions">
            <asp:Button ID="btnNuevo" runat="server" CssClass="btn accent" Text="Nuevo" />
            <asp:Button ID="btnBuscar" runat="server" CssClass="btn" Text="Buscar" />
            <asp:Button ID="btnModificar" runat="server" CssClass="btn" Text="Modificar" />
            <asp:Button ID="btnLimpiar" runat="server" CssClass="btn ghost" Text="Limpiar" />
            <asp:Button ID="btnEliminar" runat="server" CssClass="btn danger" Text="Eliminar" />
        </div>
    </div>

    <div class="card">
        <h2><img src="<%= ResolveUrl("~/Imagenes/Productos.png") %>" alt="" /> Listado de Tipos de Producto</h2>
        <div class="table-wrap">
            <asp:GridView ID="tblTipoProducto" runat="server" CssClass="grid" AutoGenerateColumns="false"
                DataKeyNames="ID" GridLines="None" OnSelectedIndexChanged="tblTipoProducto_SelectedIndexChanged">
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" />
                    <asp:BoundField DataField="NOMBRE" HeaderText="NOMBRE" />
                    <asp:ButtonField Text="Seleccionar" CommandName="Select" ButtonType="Link" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>
