Imports System.Data
Imports ServiceReference1

Partial Class jdGestionarServicio
    Inherits System.Web.UI.Page

    Dim objServicio As New WebServiceSoapClient()
    Dim objTipoVehiculo As New WebServiceSoapClient()

    '================================================================
    ' AL CARGAR EL FORMULARIO
    '================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Try
                CargarTablaServicios()
                LlenarCombos()
                LimpiarFormulario()
            Catch ex As Exception
                MostrarError("Error al cargar el formulario: " & ex.Message)
            End Try
        End If
    End Sub

    '================================================================
    ' MÉTODOS DE APOYO
    '================================================================
    Private Sub CargarTablaServicios(Optional ByVal filtro As String = "")
        Try
            Dim dt As DataTable
            If filtro = "" Then
                dt = objServicio.listarServicio()
            Else
                Dim codigo As Integer
                If Integer.TryParse(filtro, codigo) Then
                    dt = objServicio.buscarServicioPorCodigo(codigo)
                Else
                    dt = objServicio.listarServicio()
                End If
            End If
            dgvServicios.DataSource = dt
            dgvServicios.DataBind()
        Catch ex As Exception
            MostrarError("Error al cargar la tabla: " & ex.Message)
        End Try
    End Sub

    Private Sub LlenarCombos()
        Try
            Dim dtServ As DataTable = objServicio.listarServiciosSimples()
            cboNombre.DataSource = dtServ
            cboNombre.DataTextField = "servicio"
            cboNombre.DataValueField = "idServicio"
            cboNombre.DataBind()
            cboNombre.Items.Insert(0, New ListItem("-- Seleccione --", "0"))

            Dim dtTipo As DataTable = objTipoVehiculo.listarTipoVehiculo()
            cboTipoVehiculo.Items.Clear()
            cboTipoVehiculo.Items.Add(New ListItem("No asignado", "No asignado"))
            For Each row As DataRow In dtTipo.Rows
                cboTipoVehiculo.Items.Add(New ListItem(row("tipoVehiculo").ToString(), row("tipoVehiculo").ToString()))
            Next
        Catch ex As Exception
            MostrarError("Error al cargar listas desplegables: " & ex.Message)
        End Try
    End Sub

    Private Sub LimpiarFormulario()
        hdnIdServicio.Value = "0"
        txtCodigo.Text = ""
        txtPrecio.Text = ""
        txtDuracion.Text = ""
        txtBuscar.Text = ""
        cboNombre.SelectedIndex = -1
        cboTipoVehiculo.SelectedIndex = -1
        lblMensaje.Text = ""
    End Sub

    '================================================================
    ' LÓGICA DE CÁLCULO DE PRECIOS
    '================================================================
    Protected Sub cboNombre_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboNombre.SelectedIndexChanged
        If cboNombre.SelectedIndex <= 0 Then
            txtDuracion.Text = ""
            txtPrecio.Text = ""
            Return
        End If
        Try
            Dim dt As DataTable = objServicio.listarServiciosSimples()
            Dim idSeleccionado As Integer = Convert.ToInt32(cboNombre.SelectedValue)
            For Each row As DataRow In dt.Rows
                If Convert.ToInt32(row("idServicio")) = idSeleccionado Then
                    txtDuracion.Text = row("duracion").ToString()
                    Exit For
                End If
            Next
            CalcularPrecioSugerido()
        Catch ex As Exception
            MostrarError("Error al calcular duración: " & ex.Message)
        End Try
    End Sub

    Protected Sub cboTipoVehiculo_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboTipoVehiculo.SelectedIndexChanged
        CalcularPrecioSugerido()
    End Sub

    Private Sub CalcularPrecioSugerido()
        If cboNombre.SelectedIndex <= 0 OrElse cboTipoVehiculo.SelectedIndex = -1 Then Return
        Dim tipoVehiculo As String = cboTipoVehiculo.SelectedValue.ToLower()
        Dim duracion As Integer = 0

        If Integer.TryParse(txtDuracion.Text, duracion) Then
            Dim precioCalculado As Decimal = duracion * 1.5D
            If tipoVehiculo.Contains("camioneta") OrElse tipoVehiculo.Contains("suv") Then
                precioCalculado += 30D
            ElseIf tipoVehiculo.Contains("van") OrElse tipoVehiculo.Contains("combi") Then
                precioCalculado += 50D
            End If
            If tipoVehiculo = "no asignado" Then precioCalculado = 0
            txtPrecio.Text = precioCalculado.ToString("0.00")
        End If
    End Sub

    '================================================================
    ' BOTONERA DE ACCIONES
    '================================================================
    Protected Sub btnNuevo_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnNuevo.Click
        LimpiarFormulario()
        Try
            txtCodigo.Text = objServicio.generarCodigoServicio().ToString()
            MostrarExito("Complete los datos para registrar un nuevo servicio.")
        Catch ex As Exception
            MostrarError("Error al generar código: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnGuardar.Click
        Try
            Dim id As Integer = Convert.ToInt32(txtCodigo.Text)
            Dim nombre As String = cboNombre.SelectedItem.Text
            Dim tiempoEstimado As Integer = Convert.ToInt32(txtDuracion.Text)
            Dim precio As Decimal = Convert.ToDecimal(txtPrecio.Text)
            Dim idTipoVehiculo As Integer = objTipoVehiculo.obtenerCodigoTipoVehiculo(cboTipoVehiculo.SelectedValue)

            objServicio.registrarServicio(id, nombre, precio, tiempoEstimado, idTipoVehiculo)
            MostrarExito("Servicio registrado correctamente.")
            LimpiarFormulario()
            CargarTablaServicios()
        Catch ex As Exception
            MostrarError("Error al guardar: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnModificar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnModificar.Click
        Try
            Dim id As Integer = Convert.ToInt32(txtCodigo.Text)
            Dim nombre As String = cboNombre.SelectedItem.Text
            Dim tiempoEstimado As Integer = Convert.ToInt32(txtDuracion.Text)
            Dim precio As Decimal = Convert.ToDecimal(txtPrecio.Text)
            Dim idTipoVehiculo As Integer = objTipoVehiculo.obtenerCodigoTipoVehiculo(cboTipoVehiculo.SelectedValue)

            objServicio.modificarServicio(id, nombre, precio, tiempoEstimado, idTipoVehiculo)
            MostrarExito("Servicio modificado correctamente.")
            LimpiarFormulario()
            CargarTablaServicios()
        Catch ex As Exception
            MostrarError("Error al modificar: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelar.Click
        LimpiarFormulario()
        CargarTablaServicios()
        MostrarExito("Operación cancelada.")
    End Sub

    '================================================================
    ' BUSCADOR Y SELECCIÓN DE TABLA
    '================================================================
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        CargarTablaServicios(txtBuscar.Text.Trim())
    End Sub

    Protected Sub txtBuscar_TextChanged(ByVal sender As Object, ByVal e As EventArgs) Handles txtBuscar.TextChanged
        CargarTablaServicios(txtBuscar.Text.Trim())
    End Sub

    Protected Sub dgvServicios_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgvServicios.RowCommand
        If e.CommandName = "Seleccionar" Then
            Dim idServicio As Integer = Convert.ToInt32(e.CommandArgument)
            hdnIdServicio.Value = idServicio.ToString()
            ' ... (la lógica de llenado de celdas sigue igual)
        End If
    End Sub

    Private Sub MostrarError(ByVal mensaje As String)
        lblMensaje.ForeColor = System.Drawing.Color.Red
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarExito(ByVal mensaje As String)
        lblMensaje.ForeColor = System.Drawing.Color.Green
        lblMensaje.Text = mensaje
    End Sub
End Class