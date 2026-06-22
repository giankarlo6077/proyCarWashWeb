Imports System.Data
Imports capaNegocio

Partial Class jdMantenimientoTrabajador
    Inherits System.Web.UI.Page

    Dim objTrabajador As New clsTrabajador()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' Protegemos la página
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            listar()
            ' Agregar confirmación en cliente al botón Dar de Baja
            btnDarBaja.OnClientClick = "return confirmarBaja();"
        End If
    End Sub

    '========================================
    ' LISTAR
    '========================================
    Sub listar()
        Try
            lblMensaje.Text = ""
            Dim dt As DataTable = objTrabajador.ListarUsuariosGrid(txtBuscar.Text.Trim())
            dgvTrabajador.DataSource = dt
            dgvTrabajador.DataBind()
        Catch ex As Exception
            MostrarError("Error al listar trabajadores: " & ex.Message)
        End Try
    End Sub

    '========================================
    ' BUSCAR
    '========================================
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs)
        listar()
    End Sub

    Protected Sub txtBuscar_TextChanged(ByVal sender As Object, ByVal e As EventArgs) Handles txtBuscar.TextChanged
        listar()
    End Sub

    '========================================
    ' SELECCIONAR FILA
    '========================================
    Protected Sub dgvTrabajador_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "SelectRow" Then
            Dim idSelected As String = Convert.ToString(e.CommandArgument)
            hdnIdTrabajadorSeleccionado.Value = idSelected
            listar()
        End If
    End Sub

    Protected Sub dgvTrabajador_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim idSelected As Integer = Convert.ToInt32(hdnIdTrabajadorSeleccionado.Value)
            Dim rowId As Integer = Convert.ToInt32(dgvTrabajador.DataKeys(e.Row.RowIndex).Value)

            If rowId = idSelected Then
                e.Row.CssClass = "fila-seleccionada"
            End If
        End If
    End Sub

    '========================================
    ' NUEVO
    '========================================
    Protected Sub btnNuevo_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("jdGestionarTrabajador.aspx")
    End Sub

    '========================================
    ' EDITAR
    '========================================
    Protected Sub btnEditar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim idSelected As Integer = Convert.ToInt32(hdnIdTrabajadorSeleccionado.Value)
        If idSelected = 0 Then
            MostrarError("Por favor, seleccione un trabajador de la lista.")
            Exit Sub
        End If

        Response.Redirect("jdGestionarTrabajador.aspx?id=" & idSelected)
    End Sub

    '========================================
    ' DAR BAJA
    '========================================
    Protected Sub btnDarBaja_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim idSelected As Integer = Convert.ToInt32(hdnIdTrabajadorSeleccionado.Value)
        If idSelected = 0 Then
            MostrarError("Por favor, seleccione un trabajador de la lista.")
            Exit Sub
        End If

        Try
            objTrabajador.cambiarEstadoTrabajador(idSelected, False)
            MostrarExito("Trabajador dado de baja correctamente.")
            hdnIdTrabajadorSeleccionado.Value = "0"
            listar()
        Catch ex As Exception
            MostrarError("Error al dar de baja al trabajador: " & ex.Message)
        End Try
    End Sub

    '========================================
    Protected Sub btnCerrar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("FrmMenuPrincipal.aspx")
    End Sub

    '========================================
    ' HELPERS MENSAJES
    '========================================
    Private Sub MostrarError(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-info mensaje-error"
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarExito(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-info mensaje-exito"
        lblMensaje.Text = mensaje
    End Sub

End Class
