<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" Title="Inicio" %>

<asp:Content ID="cTitulo" ContentPlaceHolderID="titulo" runat="server">Inicio</asp:Content>

<asp:Content ID="cBody" ContentPlaceHolderID="cuerpo" runat="server">

    <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

    <div class="card">
        <h2><img src="<%= ResolveUrl("~/Imagenes/Inicio.png") %>" alt="" /> Bienvenido al módulo de Productos</h2>
        <p style="color:var(--muted);margin:0;">
            Gestiona productos, marcas, tipos de producto y la papelera de baja desde el menú lateral.
        </p>
    </div>

    <div class="cards-row">
        <div class="stat">
            <div class="ic"><img src="<%= ResolveUrl("~/Imagenes/Productos.png") %>" alt="" /></div>
            <div>
                <div class="num"><asp:Literal ID="litProductos" runat="server" Text="0" /></div>
                <div class="lbl">Productos vigentes</div>
            </div>
        </div>
        <div class="stat">
            <div class="ic"><img src="<%= ResolveUrl("~/Imagenes/anadir.png") %>" alt="" /></div>
            <div>
                <div class="num"><asp:Literal ID="litMarcas" runat="server" Text="0" /></div>
                <div class="lbl">Marcas registradas</div>
            </div>
        </div>
        <div class="stat">
            <div class="ic"><img src="<%= ResolveUrl("~/Imagenes/agregar-producto.png") %>" alt="" /></div>
            <div>
                <div class="num"><asp:Literal ID="litTipos" runat="server" Text="0" /></div>
                <div class="lbl">Tipos de producto</div>
            </div>
        </div>
        <div class="stat">
            <div class="ic"><img src="<%= ResolveUrl("~/Imagenes/bolsa-de-valores.png") %>" alt="" /></div>
            <div>
                <div class="num"><asp:Literal ID="litPapelera" runat="server" Text="0" /></div>
                <div class="lbl">En papelera</div>
            </div>
        </div>
    </div>

</asp:Content>
