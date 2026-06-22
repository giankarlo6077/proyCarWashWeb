<%@ Page Title="Gestión de Empresas" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarEmpresa.aspx.vb" Inherits="jdGestionarEmpresa" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .titulo-modulo {
            background-color: #111827;
            color: white;
            text-align: center;
            padding: 25px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .titulo-modulo h1 {
            margin: 0;
            font-size: 20pt;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .panel-grid {
            display: grid;
            grid-template-columns: 1fr 1.3fr;
            gap: 30px;
            align-items: start;
        }

        .panel-box {
            border: 1px dashed #D1D5DB;
            border-radius: 6px;
            padding: 20px;
            background-color: #FFFFFF;
            box-sizing: border-box;
        }

        .contenedor-tabla-scroll {
            max-height: 400px; 
            overflow-y: auto;
            border: 1px solid #E5E7EB;
            border-radius: 4px;
            margin-top: 10px;
        }

        .campo-form {
            margin-bottom: 16px;
        }

        .campo-form label {
            display: block;
            font-size: 9.5pt;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 6px;
        }

        .campo-form .form-control {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            box-sizing: border-box;
        }

        .campo-form .form-control:disabled {
            background-color: #F3F4F6;
            color: #6B7280;
            cursor: not-allowed;
        }

        .fila-buscar {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }

        .fila-buscar .form-control {
            flex: 1;
        }

        .botonera {
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 25px;
        }

        .btn-accion {
            border: none;
            border-radius: 4px;
            padding: 10px 18px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            cursor: pointer;
            color: white;
            text-transform: uppercase;
        }

        .btn-modificar { background-color: #2563EB; }
        .btn-modificar:hover { background-color: #1D4ED8; }

        .btn-cancelar { background-color: #DC2626; }
        .btn-cancelar:hover { background-color: #B91C1C; }

        .btn-limpiar { 
            background-color: #FFFFFF; 
            color: #1F2937;
            border: 1px solid #D1D5DB;
        }
        .btn-limpiar:hover { background-color: #F9FAFB; }

        .btn-cerrar {
            background-color: #FFFFFF;
            color: #000000;
            border: 2px solid #000000;
        }
        .btn-cerrar:hover {
            background-color: #F3F4F6;
        }

        .grid-usuarios {
            width: 100%;
            border-collapse: collapse;
            font-size: 9.5pt;
        }

        .grid-usuarios th {
            background-color: #1F2937;
            color: white;
            padding: 10px;
            text-align: left;
            position: sticky;
            top: 0;
            z-index: 1;
        }

        .grid-usuarios td {
            padding: 8px 10px;
            border-bottom: 1px solid #E5E7EB;
        }

        .grid-usuarios tr:hover {
            background-color: #F3F4F6;
        }

        .fila-seleccionada {
            background-color: #E0E7FF !important;
            font-weight: bold;
        }

        .btn-seleccionar {
            background-color: #1F2937;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 5px 12px;
            font-size: 8pt;
            cursor: pointer;
        }

        .btn-seleccionar:hover {
            background-color: #374151;
        }

        .mensaje-error {
            color: #DC2626;
            font-size: 9.5pt;
            display: block;
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
        }

        .mensaje-exito {
            color: #059669;
            font-size: 9.5pt;
            display: block;
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
        }

        @media (max-width: 900px) {
            .panel-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="titulo-modulo">
        <h1>Gestión de Empresas</h1>
    </div>

    <div class="panel-grid">
        
        <div class="panel-box">
            <asp:HiddenField ID="hdnIdEmpresaSeleccionado" runat="server" Value="0" />

            <div class="campo-form">
                <label>Razón Social:</label>
                <asp:TextBox ID="txtRazonSocial" runat="server" CssClass="form-control" placeholder="Razón social de la empresa..."></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>RUC:</label>
                <asp:TextBox ID="txtRUC" runat="server" CssClass="form-control" placeholder="11 dígitos..." MaxLength="11"></asp:TextBox>
            </div>

            <div class="botonera">
                <asp:Button ID="btnModificar" runat="server" Text="Modificar" CssClass="btn-accion btn-modificar" OnClick="btnModificar_Click" />
                <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" CssClass="btn-accion btn-cancelar" OnClick="btnEliminar_Click" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-accion btn-limpiar" OnClick="btnLimpiar_Click" CausesValidation="false" />
                <asp:Button ID="btnCerrar" runat="server" Text="Cancelar" CssClass="btn-accion btn-cerrar" OnClick="btnCerrar_Click" CausesValidation="false" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </div>

        <div class="panel-box">
            <div class="fila-buscar">
                <asp:TextBox ID="txtEmpresa" runat="server" CssClass="form-control" placeholder="Buscar empresa por nombre o razón social..." AutoPostBack="true" OnTextChanged="txtEmpresa_TextChanged"></asp:TextBox>
            </div>

            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvEmpresa" runat="server" AutoGenerateColumns="false"
                    CssClass="grid-usuarios" GridLines="None" Width="100%"
                    DataKeyNames="idEmpresa" OnRowCommand="dgvEmpresa_RowCommand" OnRowDataBound="dgvEmpresa_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="idEmpresa" HeaderText="ID" Visible="false" />
                        <asp:BoundField DataField="idCliente" HeaderText="ID Cliente" />
                        <asp:BoundField DataField="razonSocial" HeaderText="Razón Social" />
                        <asp:BoundField DataField="ruc" HeaderText="RUC" />
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:Button ID="btnSeleccionar" runat="server" Text="Seleccionar" CssClass="btn-seleccionar"
                                    CommandName="SelectRow" CommandArgument='<%# Eval("idEmpresa") & "|" & Eval("razonSocial") & "|" & Eval("ruc") %>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding: 20px; text-align: center; color: #6B7280;">
                            No se encontraron empresas registradas.
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>

    <script type="text/javascript">
        function confirmarEliminarEmpresa() {
            var id = document.getElementById('<%= hdnIdEmpresaSeleccionado.ClientID %>').value;
            if (id === "0") {
                alert("Por favor, seleccione una empresa de la lista.");
                return false;
            }
            return confirm("¿Desea eliminar la empresa seleccionada?");
        }
    </script>
</asp:Content>