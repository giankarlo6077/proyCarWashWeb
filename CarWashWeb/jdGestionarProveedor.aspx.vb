Imports System.Data
Imports capaNegocio

Partial Class jdGestionarProveedor
    Inherits System.Web.UI.Page

    Dim objProveedor As New clsProveedor()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            ' Inicializar Combo Estado
            cboEstado.Items.Clear()
            cboEstado.Items.Add(New ListItem("Activo", "Activo"))
            cboEstado.Items.Add(New ListItem("Inactivo", "Inactivo"))
            cboEstado.SelectedIndex = 0

            listar()
            deshabilitarCampos()
            estadoInicial()

            btnEliminar.OnClientClick = "return confirmarEliminarProveedor();"
        End If
    End Sub

    '========================================
    ' LISTAR
    '========================================
    Sub listar()
        Try
            lblMensaje.Text = ""
            Dim dt As DataTable = objProveedor.listarProveedor()
            DataGridView1.DataSource = dt
            DataGridView1.DataBind()
        Catch ex As Exception
            MostrarError("Error al listar proveedores: " & ex.Message)
        End Try
    End Sub

    '========================================
    ' LIMPIAR
    '========================================
    Sub limpiar()
        txtNombre.Text = ""
        txtRUC.Text = ""
        txtTelefono.Text = ""
        txtCorreo.Text = ""
        txtDireccion.Text = ""
        txtContacto.Text = ""
        cboEstado.SelectedIndex = 0
        hdnIdProveedorSeleccionado.Value = "0"

        deshabilitarCampos()
        lblMensaje.Text = ""
    End Sub

    Sub habilitarCampos()
        txtNombre.Enabled = True
        txtRUC.Enabled = True
        txtTelefono.Enabled = True
        txtCorreo.Enabled = True
        txtDireccion.Enabled = True
        txtContacto.Enabled = True
        cboEstado.Enabled = True
    End Sub

    Sub deshabilitarCampos()
        txtNombre.Enabled = False
        txtRUC.Enabled = False
        txtTelefono.Enabled = False
        txtCorreo.Enabled = False
        txtDireccion.Enabled = False
        txtContacto.Enabled = False
        cboEstado.Enabled = False
    End Sub

    '========================================
    ' ESTADOS DE BOTONES (BACKEND)
    '========================================
    Sub estadoInicial()
        btnRegistrar.Enabled = False
        btnEditar.Enabled = False
        btnEliminar.Enabled = False
    End Sub

    Sub estadoNuevo()
        btnRegistrar.Enabled = True
        btnEditar.Enabled = False
        btnEliminar.Enabled = False
    End Sub

    Sub estadoEdicion()
        btnRegistrar.Enabled = False
        btnEditar.Enabled = True
        btnEliminar.Enabled = True
    End Sub

    '========================================
    ' VALIDACIONES
    '========================================
    Function validarCampos() As Boolean
        If txtNombre.Text.Trim() = "" Then
            MostrarError("Ingrese proveedor")
            txtNombre.Focus()
            Return False
        End If

        If txtRUC.Text.Trim() = "" Then
            MostrarError("Ingrese RUC")
            txtRUC.Focus()
            Return False
        End If

        If Not IsNumeric(txtRUC.Text) Then
            MostrarError("El RUC debe contener números")
            txtRUC.Focus()
            Return False
        End If

        If txtRUC.Text.Trim().Length <> 11 Then
            MostrarError("El RUC debe tener 11 dígitos")
            txtRUC.Focus()
            Return False
        End If

        If txtTelefono.Text.Trim() = "" Then
            MostrarError("Ingrese teléfono")
            txtTelefono.Focus()
            Return False
        End If

        If Not IsNumeric(txtTelefono.Text) Then
            MostrarError("El teléfono debe contener números")
            txtTelefono.Focus()
            Return False
        End If

        If txtTelefono.Text.Trim().Length <> 9 Then
            MostrarError("El teléfono debe tener 9 dígitos")
            txtTelefono.Focus()
            Return False
        End If

        If txtCorreo.Text.Trim() = "" Then
            MostrarError("Ingrese correo")
            txtCorreo.Focus()
            Return False
        End If

        If Not txtCorreo.Text.Contains("@") Then
            MostrarError("Ingrese un correo válido")
            txtCorreo.Focus()
            Return False
        End If

        If txtDireccion.Text.Trim() = "" Then
            MostrarError("Ingrese dirección")
            txtDireccion.Focus()
            Return False
        End If

        If txtContacto.Text.Trim() = "" Then
            MostrarError("Ingrese contacto")
            txtContacto.Focus()
            Return False
        End If

        Return True
    End Function

    '========================================
    ' FILTRO DINÁMICO TEXTCHANGED
    '========================================
    Protected Sub txtBuscarProveedor_TextChanged(ByVal sender As Object, ByVal e As EventArgs) Handles txtBuscarProveedor.TextChanged
        Try
            Dim dt As DataTable = objProveedor.buscarProveedor(txtBuscarProveedor.Text.Trim())
            DataGridView1.DataSource = dt
            DataGridView1.DataBind()
        Catch ex As Exception
            MostrarError("Error al buscar proveedor: " & ex.Message)
        End Try
    End Sub

    '========================================
    ' OPERACIONES CRUD
    '========================================
    Protected Sub btnNuevo_Click(ByVal sender As Object, ByVal e As EventArgs)
        limpiar()
        habilitarCampos()
        estadoNuevo()
        txtNombre.Focus()
    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not validarCampos() Then Exit Sub

        Try
            Dim estado As Boolean = (cboEstado.SelectedValue = "Activo")

            objProveedor.registrarProveedor(
                txtNombre.Text.Trim(),
                txtRUC.Text.Trim(),
                txtTelefono.Text.Trim(),
                txtCorreo.Text.Trim(),
                txtDireccion.Text.Trim(),
                txtContacto.Text.Trim(),
                estado
            )

            MostrarExito("Proveedor registrado correctamente")
            listar()
            limpiar()
            estadoInicial()
        Catch ex As Exception
            MostrarError(ex.Message)
        End Try
    End Sub

    Protected Sub btnEditar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim idSelected As Integer = Convert.ToInt32(hdnIdProveedorSeleccionado.Value)
        If idSelected = 0 Then
            MostrarError("Seleccione un proveedor")
            Exit Sub
        End If

        If Not validarCampos() Then Exit Sub

        Try
            Dim estado As Boolean = (cboEstado.SelectedValue = "Activo")

            objProveedor.modificarProveedor(
                idSelected,
                txtNombre.Text.Trim(),
                txtRUC.Text.Trim(),
                txtTelefono.Text.Trim(),
                txtCorreo.Text.Trim(),
                txtDireccion.Text.Trim(),
                txtContacto.Text.Trim(),
                estado
            )

            MostrarExito("Proveedor modificado correctamente")
            listar()
            limpiar()
            estadoInicial()
        Catch ex As Exception
            MostrarError(ex.Message)
        End Try
    End Sub

    Protected Sub btnEliminar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim idSelected As Integer = Convert.ToInt32(hdnIdProveedorSeleccionado.Value)
        If idSelected = 0 Then
            MostrarError("Seleccione un proveedor")
            Exit Sub
        End If

        Try
            objProveedor.eliminarProveedor(idSelected)
            MostrarExito("Proveedor eliminado correctamente")
            listar()
            limpiar()
            estadoInicial()
        Catch ex As Exception
            MostrarError(ex.Message)
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As EventArgs)
        limpiar()
        estadoInicial()
        txtBuscarProveedor.Text = ""
        listar()
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' En ambiente web, redirigimos al menú principal del sistema
        Response.Redirect("FrmMenuPrincipal.aspx")
    End Sub

    '========================================
    ' EVENTOS DE SELECCIÓN GRIDVIEW
    '========================================
    Protected Sub DataGridView1_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "SelectRow" Then
            Dim argumentos As String() = e.CommandArgument.ToString().Split("|"c)

            hdnIdProveedorSeleccionado.Value = argumentos(0)
            txtNombre.Text = argumentos(1)
            txtRUC.Text = argumentos(2)
            txtTelefono.Text = argumentos(3)
            txtCorreo.Text = argumentos(4)
            txtDireccion.Text = argumentos(5)
            txtContacto.Text = argumentos(6)

            cboEstado.SelectedValue = argumentos(7)

            habilitarCampos()
            estadoEdicion()
            listar()
        End If
    End Sub

    Protected Sub DataGridView1_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim idSelected As Integer = Convert.ToInt32(hdnIdProveedorSeleccionado.Value)
            Dim rowId As Integer = Convert.ToInt32(DataGridView1.DataKeys(e.Row.RowIndex).Value)

            If rowId = idSelected Then
                e.Row.CssClass = "fila-seleccionada"
            End If
        End If
    End Sub

    '======================================
    ' HELPERS MENSAJES
    '========================================
    Private Sub MostrarError(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-error"
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarExito(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-exito"
        lblMensaje.Text = mensaje
    End Sub
End Class