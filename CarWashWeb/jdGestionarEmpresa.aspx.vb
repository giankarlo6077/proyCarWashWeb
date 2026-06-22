Imports System.Data
Imports capaNegocio

Partial Class jdGestionarEmpresa
    Inherits System.Web.UI.Page

    Dim objEmpresa As New clsEmpresa()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            listar()
            limpiar()
            btnEliminar.OnClientClick = "return confirmarEliminarEmpresa();"
        End If
    End Sub

    '========================================
    ' LISTAR EMPRESAS
    '========================================
    Sub listar()
        Try
            lblMensaje.Text = ""
            Dim dt As DataTable = objEmpresa.listarEmpresa()
            dgvEmpresa.DataSource = dt
            dgvEmpresa.DataBind()
        Catch ex As Exception
            MostrarError("Error al listar: " & ex.Message)
        End Try
    End Sub

    '========================================
    ' LIMPIAR / ESTADO INICIAL
    '========================================
    Sub limpiar()
        txtRazonSocial.Text = ""
        txtRUC.Text = ""
        hdnIdEmpresaSeleccionado.Value = "0"

        deshabilitarCampos()
        btnModificar.Enabled = False
        btnEliminar.Enabled = False
        lblMensaje.Text = ""
    End Sub

    Sub habilitarCampos()
        txtRazonSocial.Enabled = True
        txtRUC.Enabled = True
    End Sub

    Sub deshabilitarCampos()
        txtRazonSocial.Enabled = False
        txtRUC.Enabled = False
    End Sub

    '========================================
    ' VALIDAR CAMPOS
    '========================================
    Function validarCampos() As Boolean
        If txtRazonSocial.Text.Trim() = "" Then
            MostrarError("Ingrese razón social")
            txtRazonSocial.Focus()
            Return False
        End If

        If txtRUC.Text.Trim() = "" Then
            MostrarError("Ingrese RUC")
            txtRUC.Focus()
            Return False
        End If

        If Not IsNumeric(txtRUC.Text) Then
            MostrarError("El RUC debe ser numérico")
            txtRUC.Focus()
            Return False
        End If

        If txtRUC.Text.Trim().Length <> 11 Then
            MostrarError("El RUC debe tener 11 dígitos")
            txtRUC.Focus()
            Return False
        End If

        Return True
    End Function

    '========================================
    ' BUSCAR EMPRESA (ASÍNCRONO POR TEXTCHANGED)
    '========================================
    Protected Sub txtEmpresa_TextChanged(ByVal sender As Object, ByVal e As EventArgs) Handles txtEmpresa.TextChanged
        Try
            Dim dt As DataTable = objEmpresa.buscarEmpresa(txtEmpresa.Text.Trim())
            dgvEmpresa.DataSource = dt
            dgvEmpresa.DataBind()
        Catch ex As Exception
            MostrarError("Error en la búsqueda: " & ex.Message)
        End Try
    End Sub

    '========================================
    ' MODIFICAR
    '========================================
    Protected Sub btnModificar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim idEmpresaSeleccionado As Integer = Convert.ToInt32(hdnIdEmpresaSeleccionado.Value)

        If idEmpresaSeleccionado = 0 Then
            MostrarError("Seleccione una empresa")
            Exit Sub
        End If

        If Not validarCampos() Then Exit Sub

        Try
            objEmpresa.modificarEmpresa(idEmpresaSeleccionado, txtRazonSocial.Text.Trim(), txtRUC.Text.Trim())
            MostrarExito("Empresa modificada correctamente")
            listar()
            limpiar()
        Catch ex As Exception
            MostrarError(ex.Message)
        End Try
    End Sub

    '========================================
    ' ELIMINAR
    '========================================
    Protected Sub btnEliminar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim idEmpresaSeleccionado As Integer = Convert.ToInt32(hdnIdEmpresaSeleccionado.Value)

        If idEmpresaSeleccionado = 0 Then
            MostrarError("Seleccione una empresa")
            Exit Sub
        End If

        Try
            objEmpresa.eliminarEmpresa(idEmpresaSeleccionado)
            MostrarExito("Empresa eliminada correctamente")
            listar()
            limpiar()
        Catch ex As Exception
            MostrarError(ex.Message)
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As EventArgs)
        limpiar()
        txtEmpresa.Text = ""
        listar()
    End Sub

    Protected Sub btnCerrar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("FrmMenuPrincipal.aspx")
    End Sub

    '========================================
    ' MANEJO DE EVENTOS GRIDVIEW (SELECCIÓN)
    '========================================
    Protected Sub dgvEmpresa_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "SelectRow" Then
            Dim argumentos As String() = e.CommandArgument.ToString().Split("|"c)

            hdnIdEmpresaSeleccionado.Value = argumentos(0)
            txtRazonSocial.Text = argumentos(1)
            txtRUC.Text = argumentos(2)

            habilitarCampos()
            btnModificar.Enabled = True
            btnEliminar.Enabled = True

            lblMensaje.Text = ""
            listar()
        End If
    End Sub

    Protected Sub dgvEmpresa_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim idSelected As Integer = Convert.ToInt32(hdnIdEmpresaSeleccionado.Value)
            Dim rowId As Integer = Convert.ToInt32(dgvEmpresa.DataKeys(e.Row.RowIndex).Value)

            If rowId = idSelected Then
                e.Row.CssClass = "fila-seleccionada"
            End If
        End If
    End Sub

    '========================================
    ' INTERFAZ AUXILIAR DE ALERTAS
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