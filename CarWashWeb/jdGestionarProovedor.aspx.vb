Imports System.Data
Imports capaNegocio

Partial Class jdGestionarProovedor
    Inherits System.Web.UI.Page

    Dim objProveedor As New clsProveedor()

    '================================================================
    ' CARGA
    '================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        ' Búsqueda en vivo (filtrado del lado del cliente, sin postback)
        txtBuscarProveedor.Attributes("onkeyup") = "filtrarTabla(this, '" & dgvProveedores.ClientID & "');"

        If Not Page.IsPostBack Then
            Try
                Listar()
                Limpiar()
                EstadoInicial()
            Catch ex As Exception
                MostrarMensaje("Error al cargar la página: " & ex.Message, False)
            End Try
        End If

    End Sub

    '================================================================
    ' LISTAR / BUSCAR
    '================================================================
    Private Sub Listar(Optional ByVal criterio As String = "")
        If criterio = "" Then
            dgvProveedores.DataSource = objProveedor.listarProveedor()
        Else
            dgvProveedores.DataSource = objProveedor.buscarProveedor(criterio)
        End If
        dgvProveedores.DataBind()
    End Sub

    '================================================================
    ' MÉTODOS DE APOYO (equivalentes al escritorio)
    '================================================================
    Private Sub Limpiar()
        hdnId.Value = "0"
        txtNombre.Text = ""
        txtRUC.Text = ""
        txtTelefono.Text = ""
        txtCorreo.Text = ""
        txtDireccion.Text = ""
        txtContacto.Text = ""
        cboEstado.SelectedIndex = 0
        DeshabilitarCampos()
    End Sub

    Private Sub HabilitarCampos()
        txtNombre.Enabled = True
        txtRUC.Enabled = True
        txtTelefono.Enabled = True
        txtCorreo.Enabled = True
        txtDireccion.Enabled = True
        txtContacto.Enabled = True
        cboEstado.Enabled = True
    End Sub

    Private Sub DeshabilitarCampos()
        txtNombre.Enabled = False
        txtRUC.Enabled = False
        txtTelefono.Enabled = False
        txtCorreo.Enabled = False
        txtDireccion.Enabled = False
        txtContacto.Enabled = False
        cboEstado.Enabled = False
    End Sub

    Private Sub EstadoInicial()
        btnRegistrar.Enabled = False
        btnEditar.Enabled = False
        btnEliminar.Enabled = False
    End Sub

    Private Sub EstadoNuevo()
        btnRegistrar.Enabled = True
        btnEditar.Enabled = False
        btnEliminar.Enabled = False
    End Sub

    Private Sub EstadoEdicion()
        btnRegistrar.Enabled = False
        btnEditar.Enabled = True
        btnEliminar.Enabled = True
    End Sub

    '================================================================
    ' VALIDACIÓN (idéntica a validarCampos del escritorio)
    '================================================================
    Private Function ValidarCampos() As Boolean

        If txtNombre.Text.Trim() = "" Then
            Return Fallar("Ingrese proveedor.")
        End If
        If txtRUC.Text.Trim() = "" Then
            Return Fallar("Ingrese RUC.")
        End If
        If Not IsNumeric(txtRUC.Text) Then
            Return Fallar("El RUC debe contener números.")
        End If
        If txtRUC.Text.Trim().Length <> 11 Then
            Return Fallar("El RUC debe tener 11 dígitos.")
        End If
        If txtTelefono.Text.Trim() = "" Then
            Return Fallar("Ingrese teléfono.")
        End If
        If Not IsNumeric(txtTelefono.Text) Then
            Return Fallar("El teléfono debe contener números.")
        End If
        If txtTelefono.Text.Trim().Length <> 9 Then
            Return Fallar("El teléfono debe tener 9 dígitos.")
        End If
        If txtCorreo.Text.Trim() = "" Then
            Return Fallar("Ingrese correo.")
        End If
        If Not txtCorreo.Text.Contains("@") Then
            Return Fallar("Ingrese un correo válido.")
        End If
        If txtDireccion.Text.Trim() = "" Then
            Return Fallar("Ingrese dirección.")
        End If
        If txtContacto.Text.Trim() = "" Then
            Return Fallar("Ingrese contacto.")
        End If

        Return True
    End Function

    Private Function Fallar(ByVal mensaje As String) As Boolean
        MostrarMensaje(mensaje, False)
        Return False
    End Function

    '================================================================
    ' NUEVO
    '================================================================
    Protected Sub btnNuevo_Click(ByVal sender As Object, ByVal e As EventArgs)
        Limpiar()
        HabilitarCampos()
        EstadoNuevo()
        lblMensaje.Visible = False
    End Sub

    '================================================================
    ' REGISTRAR
    '================================================================
    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not ValidarCampos() Then Exit Sub

        Try
            Dim estado As Boolean = (cboEstado.SelectedValue = "Activo")

            objProveedor.registrarProveedor(
                txtNombre.Text.Trim(),
                txtRUC.Text.Trim(),
                txtTelefono.Text.Trim(),
                txtCorreo.Text.Trim(),
                txtDireccion.Text.Trim(),
                txtContacto.Text.Trim(),
                estado)

            MostrarMensaje("Proveedor registrado correctamente.", True)
            Listar()
            Limpiar()
            EstadoInicial()

        Catch ex As Exception
            MostrarMensaje("Error al registrar: " & ex.Message, False)
        End Try
    End Sub

    '================================================================
    ' SELECCIONAR FILA (equivale al CellClick del escritorio)
    '================================================================
    Protected Sub dgvProveedores_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName <> "Seleccionar" Then Exit Sub

        Try
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)
            Dim fila As DataRow = objProveedor.buscarXid(id)
            If fila Is Nothing Then
                MostrarMensaje("No se encontró el proveedor.", False)
                Exit Sub
            End If

            hdnId.Value = id.ToString()
            txtNombre.Text = fila("proveedor").ToString()
            txtRUC.Text = fila("ruc").ToString()
            txtTelefono.Text = fila("telefono").ToString()
            txtCorreo.Text = fila("correo").ToString()
            txtDireccion.Text = fila("direccion").ToString()
            txtContacto.Text = fila("contacto").ToString()
            cboEstado.SelectedValue = If(fila("estado").ToString() = "Activo", "Activo", "Inactivo")

            HabilitarCampos()
            EstadoEdicion()
            lblMensaje.Visible = False

        Catch ex As Exception
            MostrarMensaje("Error al seleccionar: " & ex.Message, False)
        End Try
    End Sub

    '================================================================
    ' EDITAR
    '================================================================
    Protected Sub btnEditar_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Convert.ToInt32(hdnId.Value) = 0 Then
            MostrarMensaje("Seleccione un proveedor.", False)
            Exit Sub
        End If

        If Not ValidarCampos() Then Exit Sub

        Try
            Dim estado As Boolean = (cboEstado.SelectedValue = "Activo")

            objProveedor.modificarProveedor(
                Convert.ToInt32(hdnId.Value),
                txtNombre.Text.Trim(),
                txtRUC.Text.Trim(),
                txtTelefono.Text.Trim(),
                txtCorreo.Text.Trim(),
                txtDireccion.Text.Trim(),
                txtContacto.Text.Trim(),
                estado)

            MostrarMensaje("Proveedor modificado correctamente.", True)
            Listar()
            Limpiar()
            EstadoInicial()

        Catch ex As Exception
            MostrarMensaje("Error al modificar: " & ex.Message, False)
        End Try
    End Sub

    '================================================================
    ' ELIMINAR (eliminación física — confirmada con confirm() en cliente)
    '================================================================
    Protected Sub btnEliminar_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Convert.ToInt32(hdnId.Value) = 0 Then
            MostrarMensaje("Seleccione un proveedor.", False)
            Exit Sub
        End If

        Try
            objProveedor.eliminarProveedor(Convert.ToInt32(hdnId.Value))
            MostrarMensaje("Proveedor eliminado correctamente.", True)
            Listar()
            Limpiar()
            EstadoInicial()

        Catch ex As Exception
            MostrarMensaje("Error al eliminar: " & ex.Message, False)
        End Try
    End Sub

    '================================================================
    ' LIMPIAR
    '================================================================
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Limpiar()
        EstadoInicial()
        lblMensaje.Visible = False
    End Sub

    '================================================================
    ' VOLVER (en el escritorio era Cancelar/Dispose)
    '================================================================
    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("JdMantenimientoProveedor.aspx")
    End Sub

    '================================================================
    ' HELPER DE MENSAJES
    '================================================================
    Private Sub MostrarMensaje(ByVal mensaje As String, ByVal exito As Boolean)
        lblMensaje.Visible = True
        lblMensaje.CssClass = If(exito, "mensaje-exito", "mensaje-error")
        lblMensaje.Text = mensaje
    End Sub

End Class
