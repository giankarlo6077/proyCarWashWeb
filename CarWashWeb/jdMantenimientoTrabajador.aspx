<%@ Page Title="Consulta de Trabajadores" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdMantenimientoTrabajador.aspx.vb" Inherits="jdMantenimientoTrabajador" %>

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
        }

        /* MODIFICADO: Ahora el contenedor fluye hacia abajo de manera uniforme */
        .panel-grid {
            display: flex;
            flex-direction: column;
            gap: 20px;
            align-items: stretch;
        }

        .panel-box {
            border: 1px dashed #D1D5DB;
            border-radius: 6px;
            padding: 20px;
            background-color: #FFFFFF;
            box-sizing: border-box;
        }

        .contenedor-tabla-scroll {
            max-height: 420px; 
            overflow-y: auto;
            border: 1px solid #E5E7EB;
            border-radius: 4px;
            margin-top: 10px;
        }

        .fila-buscar {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }

        .fila-buscar .form-control {
            flex: 1;
            padding: 8px 10px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            box-sizing: border-box;
        }

        .btn-buscar {
            background-color: #1F2937;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 0 16px;
            cursor: pointer;
            font-size: 11pt;
        }

        .btn-buscar:hover {
            background-color: #374151;
        }

        /* MODIFICADO: Centrado e igual a la botonera de la captura */
        .botonera {
            display: flex;
            gap: 12px;
            justify-content: flex-start;
            margin-top: 15px;
        }

        .btn-accion {
            border: none;
            border-radius: 4px;
            padding: 10px 24px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            cursor: pointer;
            color: white;
            text-transform: uppercase;
        }

        .btn-nuevo { background-color: #6B7280; }
        .btn-nuevo:hover { background-color: #4B5563; }

        .btn-modificar { background-color: #2563EB; }
        .btn-modificar:hover { background-color: #1D4ED8; }

        .btn-cancelar { background-color: #DC2626; }
        .btn-cancelar:hover { background-color: #B91C1C; }

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
            font-size: 9pt;
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
            font-size: 9pt;
            display: block;
            margin-top: 15px;
            text-align: center;
        }

        .mensaje-exito {
            color: #059669;
            font-size: 9pt;
            display: block;
            margin-top: 15px;
            text-align: center;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="titulo-modulo">
        <h1>MANTENIMIENTO DE TRABAJADORES</h1>
    </div>

    <div class="panel-grid">

        <div class="panel-box">
            <div class="fila-buscar">
                <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por nombre de trabajador..." AutoPostBack="true" OnTextChanged="txtBuscar_TextChanged"></asp:TextBox>
                <asp:Button ID="btnBuscar" runat="server" Text="🔍" CssClass="btn-buscar" OnClick="btnBuscar_Click" CausesValidation="false" />
            </div>

            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvTrabajador" runat="server" AutoGenerateColumns="false"
                    CssClass="grid-usuarios" GridLines="None" Width="100%"
                    DataKeyNames="ID" OnRowCommand="dgvTrabajador_RowCommand" OnRowDataBound="dgvTrabajador_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="ID" Visible="false" />
                        <asp:BoundField DataField="Empleado" HeaderText="Trabajador" />
                        <asp:BoundField DataField="Usuario" HeaderText="Usuario" />
                        <asp:TemplateField HeaderText="Activo">
                            <ItemTemplate>
                                <%# IIf(Convert.ToBoolean(Eval("Activo")), "Sí", "No") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:Button ID="btnSeleccionar" runat="server" Text="Seleccionar" CssClass="btn-seleccionar"
                                    CommandName="SelectRow" CommandArgument='<%# Eval("ID") %>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding: 20px; text-align: center; color: #6B7280;">
                            No se encontraron trabajadores.
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

       <div class="panel-box" style="text-align: center;">
            <asp:HiddenField ID="hdnIdTrabajadorSeleccionado" runat="server" Value="0" />
            

            <div class="botonera" style="justify-content: center; margin-bottom: 10px;">
                <asp:Button ID="btnNuevo" runat="server" Text="NUEVO" CssClass="btn-accion btn-nuevo" OnClick="btnNuevo_Click" CausesValidation="false" />
                <asp:Button ID="btnEditar" runat="server" Text="EDITAR" CssClass="btn-accion btn-modificar" OnClick="btnEditar_Click" CausesValidation="false" />
                <asp:Button ID="btnDarBaja" runat="server" Text="DAR BAJA" CssClass="btn-accion btn-cancelar" OnClick="btnDarBaja_Click" CausesValidation="false" />
                <asp:Button ID="btnCerrar" runat="server" Text="CERRAR" CssClass="btn-accion btn-cerrar" OnClick="btnCerrar_Click" CausesValidation="false" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </div>

    </div>

    <script type="text/javascript">
        function confirmarBaja() {
            var id = document.getElementById('<%= hdnIdTrabajadorSeleccionado.ClientID %>').value;
            if (id === "0") {
                alert("Seleccione un trabajador de la lista.");
                return false;
            }
            return confirm("¿Desea dar de baja al trabajador?");
        }
    </script>
</asp:Content>