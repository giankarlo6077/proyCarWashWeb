Imports System.Data
Imports capaNegocio

Partial Class jdGestionarTipoProducto
    Inherits System.Web.UI.Page

    Dim objTipo As New clsTipoProducto()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            listar()
        End If
    End Sub

    '====================== MÉTODOS DE APOYO ======================
    Private Sub listar()
        Try
            dgvTipos.DataSource = objTipo.listarTipoProducto()
            dgvTipos.DataBind()
        Catch ex As Exception
            MostrarError("Error al listar tipos de producto: " & ex.Message)
        End Try
    End Sub

    Private Sub limpiarForm()
        txtIdTipoProducto.Text = ""
        txtNombre.Text = ""
    End Sub

    '====================== ABRIR MODAL: REGISTRAR NUEVO ======================
    Protected Sub btnRegistrarNuevo_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrarNuevo.Click
        Try
            hdnModo.Value = "nuevo"
            limpiarForm()
            txtIdTipoProducto.Text = objTipo.generarCodigoTipoProducto().ToString()
            lblFormTitulo.Text = "Registrar Tipo de Producto"
            pnlForm.Visible = True
            lblMensaje.Text = ""
        Catch ex As Exception
            MostrarError("Error al preparar el registro: " & ex.Message)
        End Try
    End Sub

    '====================== ACCIONES POR FILA (Editar / Eliminar) ======================
    Protected Sub dgvTipos_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        Dim id As Integer
        If Not Integer.TryParse(Convert.ToString(e.CommandArgument), id) Then Exit Sub

        Select Case e.CommandName
            Case "Editar"
                Try
                    Dim fila As DataRow = objTipo.buscarXid(id)
                    If fila IsNot Nothing Then
                        hdnModo.Value = "editar"
                        txtIdTipoProducto.Text = id.ToString()
                        txtNombre.Text = Convert.ToString(fila("tipoproducto"))
                        lblFormTitulo.Text = "Modificar Tipo de Producto"
                        pnlForm.Visible = True
                        lblMensaje.Text = ""
                    End If
                Catch ex As Exception
                    MostrarError("Error al cargar el tipo de producto: " & ex.Message)
                End Try

            Case "Quitar"
                Try
                    objTipo.eliminarTipoProducto(id)
                    MostrarExito("TIPO DE PRODUCTO ELIMINADO")
                    listar()
                Catch ex As Exception
                    MostrarError("Error al eliminar: " & ex.Message)
                End Try
        End Select
    End Sub

    '====================== GUARDAR (Registrar o Modificar) ======================
    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnGuardar.Click
        If txtNombre.Text.Trim() = "" Then
            MostrarErrorModal("Ingrese el nombre del tipo de producto")
            Exit Sub
        End If
        Try
            If hdnModo.Value = "nuevo" Then
                Dim id As Integer = objTipo.generarCodigoTipoProducto()
                objTipo.registrarTipoProducto(id, txtNombre.Text.Trim())
                MostrarExito("TIPO DE PRODUCTO REGISTRADO")
            Else
                objTipo.modificarTipoProducto(Convert.ToInt32(txtIdTipoProducto.Text), txtNombre.Text.Trim())
                MostrarExito("TIPO DE PRODUCTO MODIFICADO")
            End If
            pnlForm.Visible = False
            limpiarForm()
            listar()
        Catch ex As Exception
            MostrarErrorModal("Error al guardar: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelar.Click
        pnlForm.Visible = False
        limpiarForm()
        lblMensaje.Text = ""
    End Sub

    '====================== MENSAJES ======================
    Private Sub MostrarError(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-error"
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarExito(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-exito"
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarErrorModal(ByVal mensaje As String)
        pnlForm.Visible = True
        Dim limpio As String = mensaje.Replace("'", " ").Replace(Chr(10), " ").Replace(Chr(13), " ")
        ClientScript.RegisterStartupScript(Me.GetType(), "alertaModal", "alert('" & limpio & "');", True)
    End Sub

End Class
