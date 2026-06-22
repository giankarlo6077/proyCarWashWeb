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
        Try
            dgvVehiculos.DataSource = objVehiculo.listarVehiculo()
            dgvVehiculos.DataBind()
        Catch ex As Exception
            lblMensaje.Text = "Error al listar los vehículos."
            lblMensaje.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub

    Private Sub CargarCombo()
        Try
            Dim dt As DataTable = objModeloVehiculo.listar()
            cboModelo.DataSource = dt
            cboModelo.DataTextField = "modelovehiculo"
            cboModelo.DataValueField = "idModeloVehiculo"
            cboModelo.DataBind()
            cboModelo.Items.Insert(0, New ListItem("-- Seleccione Modelo --", "0"))
        Catch ex As Exception
            lblMensaje.Text = "Error al cargar los modelos."
            lblMensaje.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub

    Protected Sub dgvVehiculos_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles dgvVehiculos.RowCommand
        If e.CommandName = "Seleccionar" Then
            Dim idSel As String = e.CommandArgument.ToString()
            hdnIdVehiculo.Value = idSel

            Try
                Dim dt As DataTable = objVehiculo.listarVehiculo()
                For Each row As DataRow In dt.Rows
                    If row("ID").ToString() = idSel Then
                        txtPlaca.Text = row("Placa").ToString()
                        txtDni.Text = row("DNI").ToString()
                        txtAño.Text = row("Año de fabricacion").ToString()
                        cboModelo.ClearSelection()
                        Dim item = cboModelo.Items.FindByText(row("Modelo").ToString())
                        If item IsNot Nothing Then item.Selected = True

                        lblMensaje.Text = "Vehículo cargado correctamente."
                        lblMensaje.ForeColor = System.Drawing.Color.Green
                        Exit For
                    End If
                Next
            Catch ex As Exception
                lblMensaje.Text = "Error al seleccionar el vehículo."
                lblMensaje.ForeColor = System.Drawing.Color.Red
            End Try
        End If
    End Sub

    ' --- LÓGICA DE BÚSQUEDA CORREGIDA ---

    ' Esto ocurre cuando haces clic en la lupa
    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        EjecutarBusqueda()
    End Sub

    ' Esto ocurre cuando cambias algo en la caja de texto y das clic fuera
    Protected Sub txtBuscar_TextChanged(sender As Object, e As EventArgs) Handles txtBuscar.TextChanged
        ' SOLO si la caja se quedó vacía, volvemos a mostrar toda la tabla
        If String.IsNullOrWhiteSpace(txtBuscar.Text) Then
            Listar()
            lblMensaje.Text = ""
        End If
        ' Si hay algo escrito, NO hacemos nada. Obligamos al usuario a dar clic en la lupa.
    End Sub

    ' Método principal de búsqueda
    Private Sub EjecutarBusqueda()
        Try
            If String.IsNullOrWhiteSpace(txtBuscar.Text) Then
                Listar()
            Else
                Dim dt As DataTable = objVehiculo.buscarPLacaTotal(txtBuscar.Text.Trim())
                dgvVehiculos.DataSource = dt
                dgvVehiculos.DataBind()
            End If
            lblMensaje.Text = ""
        Catch ex As Exception
            lblMensaje.Text = "Error en la búsqueda."
            lblMensaje.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub

    ' ------------------------------------

    Protected Sub btnNuevo_Click(sender As Object, e As EventArgs) Handles btnNuevo.Click
        LimpiarCampos()
        lblMensaje.Text = "Listo para registrar nuevo vehículo."
        lblMensaje.ForeColor = System.Drawing.Color.Black
    End Sub

    Protected Sub btnModificar_Click(sender As Object, e As EventArgs) Handles btnModificar.Click
        Try
            If hdnIdVehiculo.Value = "0" Then
                lblMensaje.Text = "Debe seleccionar un vehículo de la tabla."
                lblMensaje.ForeColor = System.Drawing.Color.Red
                Return
            End If

            Dim idClienteFinal As Integer = objVehiculo.obtenerIdClientePorDNI(txtDni.Text.Trim())

            If idClienteFinal = -1 Then
                lblMensaje.Text = "El DNI ingresado no existe en la base de datos."
                lblMensaje.ForeColor = System.Drawing.Color.Red
                Return
            End If

            Dim modeloV As Integer = objModeloVehiculo.buscarIdxNombre(cboModelo.SelectedItem.Text)

            objVehiculo.Modificar(Convert.ToInt32(hdnIdVehiculo.Value), txtPlaca.Text.Trim(), idClienteFinal, Convert.ToInt32(txtAño.Text.Trim()), modeloV)

            lblMensaje.Text = "Vehículo modificado correctamente."
            lblMensaje.ForeColor = System.Drawing.Color.Green
            Listar()
            LimpiarCampos()
        Catch ex As Exception
            lblMensaje.Text = "Error al modificar: " & ex.Message
            lblMensaje.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        Try
            If String.IsNullOrWhiteSpace(txtPlaca.Text) OrElse cboModelo.SelectedIndex <= 0 Then
                lblMensaje.Text = "Complete los campos obligatorios."
                lblMensaje.ForeColor = System.Drawing.Color.Red
                Return
            End If

            Dim idClienteFinal As Integer = objVehiculo.obtenerIdClientePorDNI(txtDni.Text.Trim())
            If idClienteFinal = -1 Then
                lblMensaje.Text = "El DNI ingresado no existe."
                lblMensaje.ForeColor = System.Drawing.Color.Red
                Return
            End If

            Dim modeloV As Integer = objModeloVehiculo.buscarIdxNombre(cboModelo.SelectedItem.Text)
            Dim nuevoId As Integer = objVehiculo.obtenercod()

            objVehiculo.registrar(nuevoId, txtPlaca.Text.Trim(), Convert.ToInt32(txtAño.Text.Trim()), modeloV, idClienteFinal)

            lblMensaje.Text = "Vehículo guardado correctamente."
            lblMensaje.ForeColor = System.Drawing.Color.Green
            Listar()
            LimpiarCampos()
        Catch ex As Exception
            lblMensaje.Text = "Error al guardar el vehículo."
            lblMensaje.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        LimpiarCampos()
        lblMensaje.Text = "Operación cancelada."
        lblMensaje.ForeColor = System.Drawing.Color.Black
    End Sub

    Private Sub LimpiarCampos()
        txtPlaca.Text = ""
        txtDni.Text = ""
        txtAño.Text = ""
        cboModelo.SelectedIndex = 0
        hdnIdVehiculo.Value = "0"
    End Sub
End Class