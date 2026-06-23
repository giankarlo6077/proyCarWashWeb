<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarUsuario.aspx.vb" Inherits="jdGestionarUsuario" %><asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
        }

        /* NUEVO: Contenedor con Scroll para la Tabla */
        .contenedor-tabla-scroll {
            max-height: 420px; /* Ajusta este alto a tu gusto */
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
            font-size: 9pt;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 5px;
        }

        .campo-form .form-control {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            box-sizing: border-box;
        }

        .campo-form .form-control:disabled {
            background-color: #F3F4F6;
            color: #6B7280;
        }

        .campo-checkbox {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 5px;
        }

        .campo-checkbox label {
            font-size: 9pt;
            color: #1F2937;
            font-weight: normal;
            margin: 0;
        }

        .fila-buscar {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }

        .fila-buscar .form-control {
            flex: 1;
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

        .botonera {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 25px;
        }

        .btn-accion {
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            cursor: pointer;
            color: white;
        }

        .btn-nuevo { background-color: #6B7280; }
        .btn-nuevo:hover { background-color: #4B5563; }

        .btn-modificar { background-color: #2563EB; }
        .btn-modificar:hover { background-color: #1D4ED8; }

        .btn-guardar { background-color: #059669; }
        .btn-guardar:hover { background-color: #047857; }

        .btn-cancelar { background-color: #DC2626; }
        .btn-cancelar:hover { background-color: #B91C1C; }

        .grid-usuarios {
            width: 100%;
            border-collapse: collapse;
            font-size: 9pt;
        }

        /* MODIFICADO: Cabeceras fijas para que no desaparezcan al usar el scroll */
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
    </style></asp:Content><asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="titulo-modulo">
        <h1>GESTIÓN DE USUARIOS Y CREDENCIALES</h1>
    </div>

    <div class="panel-grid">

        <div class="panel-box">

            <asp:HiddenField ID="hdnIdTrabajador" runat="server" Value="0" />

            <div class="campo-form">
                <label>Trabajador/Empleado:</label>
                <asp:TextBox ID="txtTrabajador" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>Usuario:</label>
                <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>Contraseña:</label>
                <asp:TextBox ID="txtContrasena" runat="server" CssClass="form-control" TextMode="Password" MaxLength="15"></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>Confirmar Contraseña:</label>
                <asp:TextBox ID="txtConfirmarContrasena" runat="server" CssClass="form-control" TextMode="Password" MaxLength="15"></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>Pregunta de Seguridad:</label>
                <asp:TextBox ID="txtPregunta" runat="server" CssClass="form-control" placeholder="Ej: ¿Ciudad de nacimiento?" ReadOnly="true"></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>Respuesta:</label>
                <asp:TextBox ID="txtRespuesta" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="campo-checkbox">
                <asp:CheckBox ID="chkActivo" runat="server" Checked="true" />
                <label>Activo</label>
            </div>

            <div class="botonera">
                <asp:Button ID="btnNuevo" runat="server" Text="NUEVO" CssClass="btn-accion btn-nuevo" OnClick="btnNuevo_Click" CausesValidation="false" />
                <asp:Button ID="btnModificar" runat="server" Text="MODIFICAR" CssClass="btn-accion btn-modificar" OnClick="btnGuardar_Click" CausesValidation="false" />
                <asp:Button ID="btnGuardar" runat="server" Text="GUARDAR" CssClass="btn-accion btn-guardar" OnClick="btnGuardar_Click" CausesValidation="false" />
                <asp:Button ID="btnCancelar" runat="server" Text="CANCELAR" CssClass="btn-accion btn-cancelar" OnClick="btnCancelar_Click" CausesValidation="false" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>

        </div>

        <div class="panel-box">

            <div class="fila-buscar">
                <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por nombre de trabajador..." AutoPostBack="true" OnTextChanged="txtBuscar_TextChanged"></asp:TextBox>
                <asp:Button ID="btnBuscar" runat="server" Text="🔍" CssClass="btn-buscar" OnClick="btnBuscar_Click" CausesValidation="false" />
            </div>

            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvUsuarios" runat="server" AutoGenerateColumns="false"
                    CssClass="grid-usuarios" GridLines="None" Width="100%"
                    DataKeyNames="ID" OnRowCommand="dgvUsuarios_RowCommand">
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
                                    CommandName="Seleccionar" CommandArgument='<%# Eval("ID") %>' CausesValidation="false" />
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

    </div>
</asp:Content>