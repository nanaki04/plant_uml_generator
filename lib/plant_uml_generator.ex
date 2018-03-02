defmodule PlantUMLGenerator do
  alias CodeParserState, as: State

  @type code_parser_state :: CodeParserState.state
  @type options :: [any]

  @class_template File.read! "templates/class.tmpl"
  @enum_template File.read! "templates/enum.tmpl"
  @enum_property_template File.read! "templates/enum_property.tmpl"
  @interface_template File.read! "templates/interface.tmpl"
  @interface_method_template File.read! "templates/interface_method.tmpl"
  @interface_property_template File.read! "templates/interface_property.tmpl"
  @method_template File.read! "templates/method.tmpl"
  @public_property_template File.read! "templates/public_property.tmpl"
  @private_property_template File.read! "templates/private_property.tmpl"
  @file_template File.read! "templates/file.tmpl"
  @namespace_template File.read! "templates/namespace.tmpl"

  @spec generate(code_parser_state, options) :: :ok
  def generate(code_parser_state, _options \\ []) do
    code_parser_state
    |> replace_accessibilities
    |> replace_descriptions
    |> BoilerplateGenerator.generate(
      extension: ".uml",
      single_file: true,
      class_template: @class_template,
      enum_template: @enum_template,
      enum_property_template: @enum_property_template,
      interface_template: @interface_template,
      interface_method_template: @interface_method_template,
      interface_property_template: @interface_property_template,
      method_template: @method_template,
      public_property_template: @public_property_template,
      private_property_template: @private_property_template,
      file_template: @file_template,
      namespace_template: @namespace_template
    )
  end

  @spec replace_accessibilities(code_parser_state) :: code_parser_state
  defp replace_accessibilities(code_parser_state) do
    code_parser_state
    |> State.Class.update_all_properties(fn property -> property
      |> State.Property.accessibility
      |> replace_accessibility
      |> (&State.Property.set_accessibility(property, &1)).()
    end)
    |> State.Class.update_all_methods(fn method -> method
      |> State.Method.accessibility
      |> replace_accessibility
      |> (&State.Method.set_accessibility(method, &1)).()
    end)
    |> State.Enum.update_all_properties(fn property -> property
      |> State.Property.accessibility
      |> replace_accessibility
      |> (&State.Property.set_accessibility(property, &1)).()
    end)
    |> State.Interface.update_all_properties(fn property -> property
      |> State.Property.accessibility
      |> replace_accessibility
      |> (&State.Property.set_accessibility(property, &1)).()
    end)
    |> State.Interface.update_all_methods(fn method -> method
      |> State.Method.accessibility
      |> replace_accessibility
      |> (&State.Method.set_accessibility(method, &1)).()
    end)
  end

  @spec replace_accessibility(String.t) :: String.t
  defp replace_accessibility("public"), do: "+"
  defp replace_accessibility("private"), do: "-"
  defp replace_accessibility(accessibility) do
    accessibility
    |> String.replace(~r/public\s/, "+")
    |> String.replace(~r/private\s/, "-")
    |> Kernel.<>(" ")
  end

  @spec replace_descriptions(code_parser_state) :: code_parser_state
  defp replace_descriptions(code_parser_state) do
    code_parser_state
    |> State.Namespace.update_all_classes(fn class -> class
      |> State.Class.description
      |> replace_description
      |> (&State.Class.set_description(class, &1)).()
    end)
    |> State.Namespace.update_all_enums(fn enum -> enum
      |> State.Class.description
      |> replace_description
      |> (&State.Class.set_description(enum, &1)).()
    end)
    |> State.Namespace.update_all_interfaces(fn interface -> interface
      |> State.Class.description
      |> replace_description
      |> (&State.Class.set_description(interface, &1)).()
    end)
    |> State.Class.update_all_properties(fn property -> property
      |> State.Property.description
      |> replace_description
      |> (&State.Property.set_description(property, &1)).()
    end)
    |> State.Class.update_all_methods(fn method -> method
      |> State.Method.description
      |> replace_description
      |> (&State.Method.set_description(method, &1)).()
    end)
    |> State.Enum.update_all_properties(fn property -> property
      |> State.Property.description
      |> replace_description
      |> (&State.Property.set_description(property, &1)).()
    end)
    |> State.Interface.update_all_properties(fn property -> property
      |> State.Property.description
      |> replace_description
      |> (&State.Property.set_description(property, &1)).()
    end)
    |> State.Interface.update_all_methods(fn method -> method
      |> State.Method.description
      |> replace_description
      |> (&State.Method.set_description(method, &1)).()
    end)
  end

  @spec replace_description(String.t) :: String.t
  defp replace_description(""), do: ""
  defp replace_description("TODO"), do: ""
  defp replace_description(description), do: " // " <> description

end
