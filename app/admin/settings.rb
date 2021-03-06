ActiveAdmin.register Setting do

  menu priority: 30

  permit_params :name, :value, :attachment

  index do
    selectable_column
    id_column
    column :name
    column :value
    column :attachment do |setting|
      attachment_tag(setting)
    end
    column :created_at
    actions
  end

  filter :name
  filter :value
  filter :created_at

  show do
    attributes_table do
      row :name
      row :value
      row :attachment do
        attachment_tag(setting)
      end
      row :created_at
      row :updated_at
    end

    active_admin_comments

    panel "Versions" do
      paginated_collection(resource.versions.page(params[:version_page]).per(20), param_name: 'version_page', download_links: false) do
        table_for collection do
          column :id
          column :event
          column :whodunnit
          column :changeset do |version|
            version.changeset.except('updated_at')
          end
          column :created_at
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :value, as: (f.object.value.size > 100 ? :text : :string)
      f.input :attachment, :hint => attachment_tag(f.object), as: :file
    end
    f.actions
  end
end
