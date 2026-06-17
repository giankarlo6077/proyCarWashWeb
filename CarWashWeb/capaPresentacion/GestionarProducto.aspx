<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="GestionarProducto.aspx.vb" Inherits="capaPresentacion_GestionarProducto" Title="Gestionar Producto" %>

<asp:Content ID="cTitulo" ContentPlaceHolderID="titulo" runat="server">Gestionar Producto</asp:Content>

<asp:Content ID="cBody" ContentPlaceHolderID="cuerpo" runat="server">

    <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

    <div class="card">
        <h2><img src="<%= ResolveUrl("~/Imagenes/Productos.png") %>" alt="" /> Datos del Producto</h2>
        <div class="form-grid">
            <div class="field">
                <label>ID</label>
                <asp:TextBox ID="txtId" runat="server" ReadOnly="true" />
            </div>
            <div class="field">
                <label>Nombre</label>
                <asp:TextBox ID="txtNombre" runat="server" />
            </div>
            <div class="field">
                <label>Stock</label>
                <asp:TextBox ID="spnStock" runat="server" TextMode="Number" Text="0" />
            </div>
            <div class="field">
                <label>Precio</label>
                <asp:TextBox ID="txtPrecio" runat="server" TextMode="Number" />
            </div>
            <div class="field">
                <label>Tipo de Producto</label>
                <asp:DropDownList ID="cboTipoProducto" runat="server" />
            </div>
            <div class="field">
                <label>Marca</label>
                <asp:DropDownList ID="cboMarcaProducto" runat="server" />
            </div>
            <div class="field check">
                <asp:CheckBox ID="chkVigencia" runat="server" Checked="true" />
                <label>Vigencia (activo)</label>
            </div>
        </div>
        <div class="actions">
            <asp:Button ID="btnNuevo" runat="server" CssClass="btn accent" Text="Nuevo" />
            <asp:Button ID="btnBuscar" runat="server" CssClass="btn" Text="Buscar" />
            <asp:Button ID="btnModificar" runat="server" CssClass="btn" Text="Modificar" />
            <asp:Button ID="btnLimpiar" runat="server" CssClass="btn ghost" Text="Limpiar" />
            <asp:Button ID="btnDarsebaja" runat="server" CssClass="btn danger" Text="Dar de baja" />
        </div>
        <div class="actions">
            <a class="btn ghost" href="GestionarTipoProducto.aspx"><img src="<%= ResolveUrl("~/Imagenes/agregar-producto.png") %>" alt="" /> Tipo de Producto</a>
            <a class="btn ghost" href="GestionarMarca.aspx"><img src="<%= ResolveUrl("~/Imagenes/anadir.png") %>" alt="" /> Marca</a>
            <a class="btn ghost" href="PapeleraProducto.aspx"><img src="<%= ResolveUrl("~/Imagenes/bolsa-de-valores.png") %>" alt="" /> Papelera</a>
        </div>
    </div>

    <div class="card">
        <h2><img src="<%= ResolveUrl("~/Imagenes/Mantenimiento.png") %>" alt="" /> Listado de Productos</h2>
        <div class="table-wrap">
            <asp:GridView ID="tblProducto" runat="server" CssClass="grid" AutoGenerateColumns="false"
                DataKeyNames="Id" GridLines="None" OnSelectedIndexChanged="tblProducto_SelectedIndexChanged">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id" />
                    <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                    <asp:BoundField DataField="stock" HeaderText="Stock" />
                    <asp:BoundField DataField="vigencia" HeaderText="Vigencia" />
                    <asp:BoundField DataField="Precio" HeaderText="Precio" />
                    <asp:BoundField DataField="TipoProducto" HeaderText="Tipo Producto" />
                    <asp:BoundField DataField="Marca" HeaderText="Marca" />
                    <asp:ButtonField Text="Seleccionar" CommandName="Select" ButtonType="Link" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>
