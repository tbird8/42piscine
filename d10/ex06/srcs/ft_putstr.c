/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_putstr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: alucas- <alucas-@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/07/05 08:23:13 by alucas-           #+#    #+#             */
/*   Updated: 2017/07/05 08:23:16 by alucas-          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_dope.h"

void	ft_putstr(char *str)
{
	while (*str)
		ft_putchar(*str++);
}