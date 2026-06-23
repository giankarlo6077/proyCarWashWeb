Imports System.Data
Imports capaNegocio

Partial Class JdMantenimientoProveedor
    Inherits System.Web.UI.Page

    Dim objProveedor As New clsProveedor()

    '================================================================
    ' CARGA DEL FORMULARIO
    '================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        ' Protección de la página (igual que el resto del sistema web)
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        ' Búsqueda en vivo (filtrado del lado del cliente, sin postback)
        txtBuscar.Attributes("onkeyup") = "filtrarTabla(this, '" & dgvProveedores.ClientID & "');"

        If Not Page.IsPostBack Then
            Try
                CargarGrilla()
            Catch ex As Exception
                MostrarMensaje("Error al cargar proveedores: " & ex.Message, False)
            End Try
        End If

    End Sub

    '================================================================
    ' CARGAR / BUSCAR GRILLA
    '   Reemplaza a configurarGrilla() + cargarGrilla() del escritorio.
    '   Las columnas ya están definidas declarativamente en el .aspx.
    '================================================================
    Private Sub CargarGrilla(Optional ByVal criterio As String = "")
        If criterio = "" Then
            dgvProveedores.DataSource = objProveedor.listarProveedor()
        Else
            dgvProveedores.DataSource = objProveedor.buscarProveedor(criterio)
        End If
        dgvProveedores.DataBind()
    End Sub

    ' VOLVER AL MENÚ PRINCIPAL
    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("FrmMenuPrincipal.aspx")
    End Sub

    '================================================================
    ' COMANDOS DE FILA (Editar / Dar de baja)
    '   En el escritorio eran botones separados habilitados al
    '   seleccionar una fila; en web cada fila trae sus acciones.
    '================================================================
    Protected Sub dgvProveedores_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        Dim idProveedor As Integer = Convert.ToInt32(e.CommandArgument)

        Select Case e.CommandName
            Case "Editar"
                AbrirModalEditar(idProveedor)
            Case "Baja"
                DarDeBaja(idProveedor)
        End Select
    End Sub

    '================================================================
    ' ABRIR MODAL DE EDICIÓN (equivale a frmEditarProveedor.New)
    '================================================================
    Private Sub AbrirModalEditar(ByVal idProveedor As Integer)
        Try
            Dim fila As DataRow = objProveedor.buscarXid(idProveedor)
            If fila Is Nothing Then
                MostrarMensaje("No se encontró el proveedor seleccionado.", False)
                Exit Sub
            End If

            hdnIdProveedor.Value = idProveedor.ToString()
            txtNombre.Text = fila("proveedor").ToString()
            txtRUC.Text = fila("ruc").ToString()
            txtTelefono.Text = fila("telefono").ToString()
            txtCorreo.Text = fila("correo").ToString()
            txtDireccion.Text = fila("direccion").ToString()
            txtContacto.Text = fila("contacto").ToString()
            cboEstado.SelectedValue = If(fila("estado").ToString() = "Activo", "Activo", "Inactivo")

            lblModalTitulo.Text = "Editar Proveedor"
            lblModalMensaje.Visible = False
            lblModalMensaje.Text = ""
            pnlModal.Visible = True

        Catch ex As Exception
            MostrarMensaje("Error al abrir el proveedor: " & ex.Message, False)
        End Try
    End Sub

    '================================================================
    ' GUARDAR CAMBIOS (modal)  — replica frmEditarProveedor.validar()
    '================================================================
    Protected Sub btnGuardarModal_Click(ByVal sender As Object, ByVal e As EventArgs)

        ' Si no pasa la validación, dejamos el modal abierto con el mensaje
        If Not ValidarModal() Then
            pnlModal.Visible = True
            Exit Sub
        End If

        Try
            Dim idProveedor As Integer = Convert.ToInt32(hdnIdProveedor.Value)
            Dim estado As Boolean = (cboEstado.SelectedValue = "Activo")

            If idProveedor = 0 Then
                ' Modo NUEVO → registrar
                objProveedor.registrarProveedor(
                    txtNombre.Text.Trim(),
                    txtRUC.Text.Trim(),
                    txtTelefono.Text.Trim(),
                    txtCorreo.Text.Trim(),
                    txtDireccion.Text.Trim(),
                    txtContacto.Text.Trim(),
                    estado)
            Else
                ' Modo EDITAR → modificar
                objProveedor.modificarProveedor(
                    idProveedor,
                    txtNombre.Text.Trim(),
                    txtRUC.Text.Trim(),
                    txtTelefono.Text.Trim(),
                    txtCorreo.Text.Trim(),
                    txtDireccion.Text.Trim(),
                    txtContacto.Text.Trim(),
                    estado)
            End If

            pnlModal.Visible = False
            CargarGrilla()
            MostrarMensaje(If(idProveedor = 0, "Proveedor registrado correctamente.", "Proveedor actualizado correctamente."), True)

        Catch ex As Exception
            ' Error en BD → mantenemos el modal abierto mostrando el detalle
            pnlModal.Visible = True
            MostrarMensajeModal(ex.Message)
        End Try

    End Sub

    '================================================================
    ' CANCELAR (modal)
    '================================================================
    Protected Sub btnCancelarModal_Click(ByVal sender As Object, ByVal e As EventArgs)
        pnlModal.Visible = False
    End Sub

    '================================================================
    ' DAR DE BAJA (baja lógica: estado = False)
    '   La confirmación YesNo del escritorio se hace con confirm()
    '   en el OnClientClick del botón de la grilla.
    '================================================================
    Private Sub DarDeBaja(ByVal idProveedor As Integer)
        Try
            Dim fila As DataRow = objProveedor.buscarXid(idProveedor)
            If fila Is Nothing Then
                MostrarMensaje("No se encontró el proveedor seleccionado.", False)
                Exit Sub
            End If

            If fila("estado").ToString() = "Inactivo" Then
                MostrarMensaje("El proveedor ya se encuentra inactivo.", False)
                Exit Sub
            End If

            objProveedor.modificarProveedor(
                idProveedor,
                fila("proveedor").ToString(),
                fila("ruc").ToString(),
                fila("telefono").ToString(),
                fila("correo").ToString(),
                fila("direccion").ToString(),
                fila("contacto").ToString(),
                False)

            CargarGrilla()
            MostrarMensaje("Proveedor '" & fila("proveedor").ToString() & "' dado de baja correctamente.", True)

        Catch ex As Exception
            MostrarMensaje("Error al dar de baja: " & ex.Message, False)
        End Try
    End Sub

    '================================================================
    ' VALIDACIÓN DEL MODAL (idéntica a frmEditarProveedor.validar)
    '================================================================
    Private Function ValidarModal() As Boolean

        If txtNombre.Text.Trim() = "" Then
            Return FallarModal("Ingrese el nombre del proveedor.")
        End If

        If txtRUC.Text.Trim() = "" Then
            Return FallarModal("Ingrese el RUC.")
        End If

        If Not IsNumeric(txtRUC.Text) Then
            Return FallarModal("El RUC debe contener solo números.")
        End If

        If txtRUC.Text.Trim().Length <> 11 Then
            Return FallarModal("El RUC debe tener exactamente 11 dígitos.")
        End If

        If txtTelefono.Text.Trim() = "" Then
            Return FallarModal("Ingrese el teléfono.")
        End If

        If Not IsNumeric(txtTelefono.Text) Then
            Return FallarModal("El teléfono debe contener solo números.")
        End If

        If txtTelefono.Text.Trim().Length <> 9 Then
            Return FallarModal("El teléfono debe tener exactamente 9 dígitos.")
        End If

        If txtCorreo.Text.Trim() = "" Then
            Return FallarModal("Ingrese el correo electrónico.")
        End If

        If Not txtCorreo.Text.Contains("@") Then
            Return FallarModal("Ingrese un correo electrónico válido.")
        End If

        If txtDireccion.Text.Trim() = "" Then
            Return FallarModal("Ingrese la dirección.")
        End If

        If txtContacto.Text.Trim() = "" Then
            Return FallarModal("Ingrese el nombre de la persona de contacto.")
        End If

        Return True

    End Function

    ' Helper: muestra el mensaje en el modal y devuelve False (corta la validación)
    Private Function FallarModal(ByVal mensaje As String) As Boolean
        MostrarMensajeModal(mensaje)
        Return False
    End Function

    '================================================================
    ' HELPERS DE MENSAJES
    '================================================================
    Private Sub MostrarMensaje(ByVal mensaje As String, ByVal exito As Boolean)
        lblMensaje.Visible = True
        lblMensaje.CssClass = If(exito, "mensaje-exito", "mensaje-error")
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarMensajeModal(ByVal mensaje As String)
        lblModalMensaje.Visible = True
        lblModalMensaje.Text = mensaje
    End Sub

End Class
