Imports System.Data
Imports System.Collections.Generic
Imports capaNegocio

Partial Class jdGestionarVehiculo
    Inherits System.Web.UI.Page

    Dim objVehiculo As New clsVehiculo()
    Dim objModeloVehiculo As New clsModeloVehiculo()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Listar()
            CargarCombo()
        End If
    End Sub

    Private Sub Listar()
        dgvVehiculos.DataSource = objVehiculo.listarVehiculo()
        dgvVehiculos.DataBind()
    End Sub

    Private Sub CargarCombo()
        Try
            Dim dt As DataTable = objModeloVehiculo.listar()
            cboModelo.DataSource = dt
            cboModelo.DataTextField = "modelovehiculo"
            cboModelo.DataValueField = "idModeloVehiculo"
            cboModelo.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub dgvVehiculos_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles dgvVehiculos.RowCommand
        If e.CommandName = "Seleccionar" Then
            Dim idSel As String = e.CommandArgument.ToString()
            hdnIdVehiculo.Value = idSel
            Dim dt As DataTable = objVehiculo.listarVehiculo()
            For Each row As DataRow In dt.Rows
                If row("ID").ToString() = idSel Then
                    txtPlaca.Text = row("Placa").ToString()
                    txtDni.Text = row("DNI").ToString()
                    txtAño.Text = row("Año de fabricacion").ToString()
                    cboModelo.ClearSelection()
                    Dim item = cboModelo.Items.FindByText(row("Modelo").ToString())
                    If item IsNot Nothing Then item.Selected = True
                    Exit For
                End If
            Next
        End If
    End Sub

    Protected Sub btnModificar_Click(sender As Object, e As EventArgs) Handles btnModificar.Click
        Try
            If hdnIdVehiculo.Value = "0" Then Return
            Dim idClienteFinal As Integer = objVehiculo.obtenerIdClientePorDNI(txtDni.Text.Trim())
            Dim modeloV As Integer = objModeloVehiculo.buscarIdxNombre(cboModelo.SelectedItem.Text)
            objVehiculo.Modificar(Convert.ToInt32(hdnIdVehiculo.Value), txtPlaca.Text.Trim(), idClienteFinal, Convert.ToInt32(txtAño.Text.Trim()), modeloV)
            Listar()
            LimpiarCampos()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        LimpiarCampos()
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        Listar()
    End Sub

    Protected Sub btnNuevo_Click(sender As Object, e As EventArgs) Handles btnNuevo.Click
        LimpiarCampos()
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        If String.IsNullOrWhiteSpace(txtBuscar.Text) Then
            Listar()
        Else
            dgvVehiculos.DataSource = objVehiculo.buscarPLacaTotal(txtBuscar.Text.Trim())
            dgvVehiculos.DataBind()
        End If
    End Sub

    Private Sub LimpiarCampos()
        txtPlaca.Text = ""
        txtDni.Text = ""
        txtAño.Text = ""
        cboModelo.SelectedIndex = -1
        hdnIdVehiculo.Value = "0"
    End Sub
End Class