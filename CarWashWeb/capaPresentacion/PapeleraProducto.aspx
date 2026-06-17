<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="PapeleraProducto.aspx.vb" Inherits="capaPresentacion_PapeleraProducto" Title="Papelera de Productos" %>

<asp:Content ID="cTitulo" ContentPlaceHolderID="titulo" runat="server">Papelera de Productos</asp:Content>

<asp:Content ID="cBody" ContentPlaceHolderID="cuerpo" runat="server">

    <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

    <div class="card">
        <h2><img src="<%= ResolveUrl("~/Imagenes/bolsa-de-valores.png") %>" alt="" /> Productos dados de baja</h2>
        <div class="form-grid">
            <div class="field">
                <label>ID seleccionado</label>
                <asp:TextBox ID="txtId" runat="server" ReadOnly="true" />
            </div>
        </div>
        <div class="actions">
            <asp:Button ID="btnRecuperar" runat="server" CssClass="btn success" Text="Recuperar" />
            <asp:Button ID="btnEliminar" runat="server" CssClass="btn danger" Text="Eliminar definitivo"
                OnClientClick="return confirm('¿Realmente quiere eliminar definitivamente este producto?');" />
            <asp:Button ID="btnActualizar" runat="server" CssClass="btn ghost" Text="Actualizar" />
            <a class="btn ghost" href="GestionarProducto.aspx">Volver</a>
        </div>
    </div>

    <div class="card">
        <h2><img src="<%= ResolveUrl("~/Imagenes/cargando-flechas.png") %>" alt="" /> Listado de la Papelera</h2>
        <div class="table-wrap">
            <asp:GridView ID="tblPapelera" runat="server" CssClass="grid" AutoGenerateColumns="false"
                DataKeyNames="Id" GridLines="None" OnSelectedIndexChanged="tblPapelera_SelectedIndexChanged">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id" />
                    <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                    <asp:BoundField DataField="stock" HeaderText="Stock" />
                    <asp:BoundField DataField="Precio" HeaderText="Precio" />
                    <asp:BoundField DataField="TipoProducto" HeaderText="Tipo Producto" />
                    <asp:BoundField DataField="Marca" HeaderText="Marca" />
                    <asp:ButtonField Text="Seleccionar" CommandName="Select" ButtonType="Link" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>
