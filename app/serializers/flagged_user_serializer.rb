class FlaggedUserSerializer < BasicUserSerializer
  attributes :can_delete_all_posts,
             :can_be_deleted,
             :post_count,
             :topic_count,
             :ip_address,
             :custom_fields

  def can_delete_all_posts
    scope.can_delete_all_posts?(object)
  end

  def can_be_deleted
    scope.can_delete_user?(object)
  end

  def ip_address
    object.ip_address.try(:to_s)
  end

  def custom_fields
    fields = User.whitelisted_user_custom_fields(scope)

    if scope.can_edit?(object)
      fields += DiscoursePluginRegistry.serialized_current_user_fields.to_a
    end

    if fields.present?
      User.custom_fields_for_ids([object.id], fields)[object.id] || {}
    else
      {}
    end
  end

end
